#import "client.h"
#import "protocol.h"

#include <sys/socket.h>
#include <sys/un.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <mach-o/dyld.h>

int client_connect(void) {
    char path[256];
    menu_socket_path(path, sizeof(path));

    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) return -1;

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, path, sizeof(addr.sun_path) - 1);

    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(fd);
        return -1;
    }
    return fd;
}

void client_send(int fd, const char *msg) {
    write(fd, msg, strlen(msg));
}

char *client_recv(int fd) {
    char buf[512];
    ssize_t total = 0;
    while (total < (ssize_t)sizeof(buf) - 1) {
        ssize_t n = read(fd, buf + total, sizeof(buf) - 1 - total);
        if (n <= 0) break;
        total += n;
        // Stop at newline
        if (total > 0 && buf[total - 1] == '\n') break;
    }
    buf[total] = '\0';
    // Strip trailing newline
    if (total > 0 && buf[total - 1] == '\n') buf[total - 1] = '\0';
    return strdup(buf);
}

void client_spawn_server(const char *execPath) {
    (void)execPath;  // unused — we resolve the path ourselves

    // Resolve the absolute path of the current binary
    char selfPath[1024];
    uint32_t size = sizeof(selfPath);
    if (_NSGetExecutablePath(selfPath, &size) != 0) {
        fprintf(stderr, "Menu: failed to resolve executable path\n");
        return;
    }

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return;
    }
    if (pid == 0) {
        // Child: become the server process
        setsid();
        // Close stdin/stdout/stderr and redirect to /dev/null
        close(STDIN_FILENO);
        close(STDOUT_FILENO);
        close(STDERR_FILENO);
        int devnull = open("/dev/null", O_RDWR);
        if (devnull >= 0) {
            dup2(devnull, STDIN_FILENO);
            dup2(devnull, STDOUT_FILENO);
            dup2(devnull, STDERR_FILENO);
            if (devnull > 2) close(devnull);
        }
        execl(selfPath, selfPath, "--_server-internal", NULL);
        _exit(1);  // exec failed
    }
    // Parent: brief initial wait for server to start
    usleep(50000);  // 50ms
}
