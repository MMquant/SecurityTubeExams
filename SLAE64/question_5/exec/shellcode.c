// shellcode.c
// shellcode testing wrapper

#include<stdio.h>
#include<string.h>

// msfvenom -p linux/x64/exec -f c -a x64 --platform linux CMD=ls
unsigned char code[] = \
"\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00\x53"
"\x48\x89\xe7\x68\x2d\x63\x00\x00\x48\x89\xe6\x52\xe8\x03\x00"
"\x00\x00\x6c\x73\x00\x56\x57\x48\x89\xe6\x0f\x05";

main()
{
        printf("Shellcode Length:  %zd\n", strlen(code));
        int (*CodeFun)() = (int(*)())code;
        CodeFun();
}
