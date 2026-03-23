#ifndef MENU_CLIENT_H
#define MENU_CLIENT_H

// Connect to the server's Unix socket.
// Returns the file descriptor on success, -1 on failure.
int client_connect(void);

// Send a message to the server.
void client_send(int fd, const char *msg);

// Receive a response from the server.
// Returns a malloc'd string (caller must free), or NULL on failure.
char *client_recv(int fd);

// Fork and exec a new server process in the background.
// execPath is argv[0] of the current process.
// Blocks for a short time to let the server start.
void client_spawn_server(const char *execPath);

#endif
