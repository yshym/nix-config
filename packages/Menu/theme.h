#ifndef MENU_THEME_H
#define MENU_THEME_H

#import <Cocoa/Cocoa.h>

// --- Color conversion macro ---

#define THEME_HEX(hex) \
    [NSColor colorWithRed:((hex >> 16) & 0xFF) / 255.0 \
                    green:((hex >> 8) & 0xFF) / 255.0 \
                     blue:(hex & 0xFF) / 255.0 \
                    alpha:1.0]

// --- Colors (Dracula) ---

#define THEME_COLOR_BG      0x282A36
#define THEME_COLOR_FG      0xF8F8F2
#define THEME_COLOR_SEL     0x44475A
#define THEME_COLOR_ACCENT  0xBD93F9
#define THEME_COLOR_INPUT   0x1E1F2E

// --- Font sizes ---

#define THEME_FONT_SIZE_SEARCH  18
#define THEME_FONT_SIZE_LIST    14

#endif
