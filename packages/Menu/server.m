#import "server.h"
#import "app.h"
#import "scan.h"
#import "protocol.h"

#import <Cocoa/Cocoa.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <signal.h>
#include <string.h>

static char g_socket_path[256];

static void cleanup_socket(void) {
    unlink(g_socket_path);
}

static void sigterm_handler(int sig) {
    (void)sig;
    cleanup_socket();
    _exit(0);
}

void server_run(void) {
    menu_socket_path(g_socket_path, sizeof(g_socket_path));

    // Remove stale socket
    unlink(g_socket_path);

    // Install signal handlers for clean shutdown
    signal(SIGTERM, sigterm_handler);
    signal(SIGINT, sigterm_handler);
    atexit(cleanup_socket);

    // Create Unix domain socket
    int server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("socket");
        exit(1);
    }

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, g_socket_path, sizeof(addr.sun_path) - 1);

    if (bind(server_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind");
        close(server_fd);
        exit(1);
    }

    if (listen(server_fd, 5) < 0) {
        perror("listen");
        close(server_fd);
        exit(1);
    }

    // Create NSApplication
    NSApplication *nsApp = [NSApplication sharedApplication];
    [nsApp setActivationPolicy:NSApplicationActivationPolicyAccessory];

    // Create AppDelegate in server mode
    AppDelegate *delegate = [[AppDelegate alloc] init];
    delegate.serverMode = YES;
    delegate.clientFd = -1;
    [delegate reloadApps];
    [nsApp setDelegate:delegate];

    // Accept connections on a background dispatch queue
    dispatch_queue_t queue = dispatch_queue_create(
        "menu.server.accept", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        while (1) {
            int client_fd = accept(server_fd, NULL, NULL);
            if (client_fd < 0) continue;

            // Read command
            char buf[256];
            ssize_t n = read(client_fd, buf, sizeof(buf) - 1);
            if (n <= 0) {
                close(client_fd);
                continue;
            }
            buf[n] = '\0';

            // Dispatch to main thread
            if (strncmp(buf, CMD_DRUN, strlen(CMD_DRUN)) == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate showDrun:client_fd];
                });
            } else if (strncmp(buf, CMD_RELOAD, strlen(CMD_RELOAD)) == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate reloadApps];
                    write(client_fd, RESP_OK, strlen(RESP_OK));
                    close(client_fd);
                });
            } else if (strncmp(buf, CMD_STOP, strlen(CMD_STOP)) == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    write(client_fd, RESP_OK, strlen(RESP_OK));
                    close(client_fd);
                    cleanup_socket();
                    close(server_fd);
                    [NSApp terminate:nil];
                });
            } else {
                close(client_fd);
            }
        }
    });

    // Run the main event loop (never returns)
    [nsApp run];
}
