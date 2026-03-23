#ifndef MENU_SERVER_H
#define MENU_SERVER_H

// Start the server process. This function never returns.
// Creates a Unix socket, listens for commands, and runs the NSApplication
// event loop with a pre-rendered panel.
void server_run(void);

#endif
