#import <Cocoa/Cocoa.h>

#import "app.h"
#import "client.h"
#import "server.h"
#import "scan.h"
#import "protocol.h"

#include <string.h>

// ---------------------------------------------------------------------------
// Read lines from stdin into an array
// ---------------------------------------------------------------------------

static NSMutableArray<NSString *> *readStdin(void) {
    NSMutableArray *lines = [NSMutableArray new];
    char buf[4096];
    while (fgets(buf, sizeof(buf), stdin)) {
        size_t len = strlen(buf);
        if (len > 0 && buf[len - 1] == '\n') buf[len - 1] = '\0';
        if (strlen(buf) > 0) {
            [lines addObject:[NSString stringWithUTF8String:buf]];
        }
    }
    return lines;
}

// ---------------------------------------------------------------------------
// Run one-shot mode (no server)
// ---------------------------------------------------------------------------

static void run_oneshot(NSMutableArray<NSString *> *items,
                        MenuMode mode,
                        NSMutableDictionary<NSString *, NSString *> *paths) {
    NSApplication *nsApp = [NSApplication sharedApplication];
    [nsApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    AppDelegate *delegate = [[AppDelegate alloc] init];
    [delegate setupWithItems:items mode:mode appPaths:paths];
    [nsApp setDelegate:delegate];
    [nsApp run];
}

// ---------------------------------------------------------------------------
// Usage
// ---------------------------------------------------------------------------

static void usage(void) {
    fprintf(stderr,
        "Usage: Menu [--drun] [--server]\n"
        "  --drun     App launcher mode (scan app directories)\n"
        "  --server   Use/spawn background server for instant startup\n"
        "  --reload   Reload app list on running server\n"
        "  --stop     Stop the background server\n"
        "  (default)  Read lines from stdin, show menu, print selection\n");
}

// ---------------------------------------------------------------------------
// main
// ---------------------------------------------------------------------------

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        BOOL drun = NO;
        BOOL withServer = NO;
        BOOL stop = NO;
        BOOL reload = NO;
        BOOL serverInternal = NO;

        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "--drun") == 0) {
                drun = YES;
            } else if (strcmp(argv[i], "--server") == 0) {
                withServer = YES;
            } else if (strcmp(argv[i], "--stop") == 0) {
                stop = YES;
            } else if (strcmp(argv[i], "--reload") == 0) {
                reload = YES;
            } else if (strcmp(argv[i], "--_server-internal") == 0) {
                serverInternal = YES;
            } else {
                usage();
                return 1;
            }
        }

        // Internal: start the server process (called after fork+exec)
        if (serverInternal) {
            server_run();
            return 0; // never reached
        }

        // --stop: tell running server to shut down
        if (stop) {
            int fd = client_connect();
            if (fd < 0) return 0; // no server, nothing to stop
            client_send(fd, CMD_STOP);
            char *resp = client_recv(fd);
            free(resp);
            close(fd);
            return 0;
        }

        // --reload: tell running server to rescan app directories
        if (reload) {
            int fd = client_connect();
            if (fd < 0) {
                fprintf(stderr, "Menu: no server running\n");
                return 1;
            }
            client_send(fd, CMD_RELOAD);
            char *resp = client_recv(fd);
            free(resp);
            close(fd);
            return 0;
        }

        // --drun mode
        if (drun) {
            // Try to connect to existing server
            int fd = client_connect();
            if (fd >= 0) {
                // Server running — use it
                client_send(fd, CMD_DRUN);
                char *resp = client_recv(fd);
                int ret = resp ? 0 : 1;
                free(resp);
                close(fd);
                return ret;
            }
            if (withServer) {
                // No server — spawn one and retry with backoff
                client_spawn_server(argv[0]);
                fd = -1;
                for (int attempt = 0; attempt < 10; attempt++) {
                    fd = client_connect();
                    if (fd >= 0) break;
                    usleep(50000);  // 50ms between retries
                }
                if (fd >= 0) {
                    client_send(fd, CMD_DRUN);
                    char *resp = client_recv(fd);
                    int ret = resp ? 0 : 1;
                    free(resp);
                    close(fd);
                    return ret;
                }
                fprintf(stderr, "Menu: failed to connect to server\n");
                return 1;
            }
            // No server, no --server flag — one-shot mode
            NSMutableArray *items = nil;
            NSMutableDictionary *paths = nil;
            scanApps(&items, &paths);
            run_oneshot(items, MODE_DRUN, paths);
            return 0;
        }

        // stdin mode (always one-shot)
        if (isatty(STDIN_FILENO)) {
            usage();
            return 1;
        }
        NSMutableArray *items = readStdin();
        run_oneshot(items, MODE_STDIN, [NSMutableDictionary new]);
        return 0;
    }
}
