// File: printVariables.c
// Author: Petr Javorik

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <unistd.h>
#include <string.h>

int main()
{
	printf("AF_INET= 0x%1$x (%1$d)\n", AF_INET);
    printf("SOCK_STREAM= 0x%1$x (%1$d)\n", SOCK_STREAM);
    printf("INADDR_ANY= 0x%1$x (%1$d)\n", INADDR_ANY);

    printf("STDIN_FILENO= 0x%1$x (%1$d)\n", STDIN_FILENO);
    printf("STDOUT_FILENO= 0x%1$x (%1$d)\n", STDOUT_FILENO);
    printf("STDERR_FILENO= 0x%1$x (%1$d)\n", STDERR_FILENO);

	struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(5051);
    addr.sin_addr.s_addr = INADDR_ANY;
	printf("sizeof(sockaddr_in)= 0x%1$zx (%1$zd)\n", sizeof(addr));
	printf("sizeof(addr.sin_family)= 0x%1$zx (%1$zd)\n", sizeof(addr.sin_family));
	printf("sizeof(addr.sin_port)= 0x%1$zx (%1$zd)\n", sizeof(addr.sin_port));
	printf("sizeof(addr.sin_addr.s_addr)= 0x%1$zx (%1$zd)\n", sizeof(addr.sin_addr.s_addr));
}
