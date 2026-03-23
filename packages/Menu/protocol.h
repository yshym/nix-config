#ifndef MENU_PROTOCOL_H
#define MENU_PROTOCOL_H

#include <stdio.h>
#include <unistd.h>

#define MENU_SOCKET_FMT "/tmp/menu-%d.sock"

#define CMD_DRUN    "drun"
#define CMD_RELOAD  "reload"
#define CMD_STOP    "stop"

#define RESP_SELECTED  "selected\n"
#define RESP_CANCELLED "cancelled\n"
#define RESP_OK        "ok\n"

static inline void menu_socket_path(char *buf, size_t len) {
    snprintf(buf, len, MENU_SOCKET_FMT, getuid());
}

#endif
