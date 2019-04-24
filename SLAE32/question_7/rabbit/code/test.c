#include <stdio.h>
#include "rabbit.c"

int main()
{
    ECRYPT_init();
    ECRYPT_ctx ctx;
    char key[16] = {'d', 'd', 'd' ,'d', 'd', 'd', 'd', 'd', 'd', 'd','d', 'd', 'd', 'd', 'd', 'd'};

    ECRYPT_keysetup(&ctx, key, 128, 0);

    u8 message[8] = {0x79, 0x0a, 0xfc, 0xb2, 0xbf, 0xad, 0x82, 0x9d};
//    char message[8] = {'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a'};
    u8 encrypted[8];
    ECRYPT_process_bytes(0, &ctx, message, encrypted, 8);

    int i;
    printf ("Message         =");
    for (i=0; i<8; i++)
        printf("%02x", message[i]);
    printf("\n");

    printf ("Encrypted         =");
    for (i=0; i<8; i++)
        printf ("%02x", encrypted[i]);
    printf ("\n");
    printf ("\n");
}
