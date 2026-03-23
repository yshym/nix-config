#import "app.h"
#import "fuzzy.h"
#import "scan.h"
#import "rowview.h"
#import "protocol.h"
#import "theme.h"

#include <sys/socket.h>

@implementation AppDelegate

// ---------------------------------------------------------------------------
// Initialization
// ---------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self setupPanel];
    if (!_serverMode) {
        _filteredItems = [_items mutableCopy];
        [_tableView reloadData];
        [self show];
    }
}

- (void)setupWithItems:(NSMutableArray<NSString *> *)items
                  mode:(MenuMode)mode
              appPaths:(NSMutableDictionary<NSString *, NSString *> *)paths {
    _items = items;
    _mode = mode;
    _appPaths = paths;
    _serverMode = NO;
    _clientFd = -1;
}

- (void)reloadApps {
    NSMutableArray *items = nil;
    NSMutableDictionary *paths = nil;
    scanApps(&items, &paths);
    _items = items;
    _appPaths = paths;
}

// ---------------------------------------------------------------------------
// Panel setup
// ---------------------------------------------------------------------------

- (void)setupPanel {
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    CGFloat panelWidth = 600;
    CGFloat panelHeight = 400;
    CGFloat panelX = (screenFrame.size.width - panelWidth) / 2;
    CGFloat panelY = (screenFrame.size.height - panelHeight) / 2
                     + screenFrame.size.height * 0.1;

    _panel = [[NSPanel alloc]
        initWithContentRect:NSMakeRect(panelX, panelY, panelWidth, panelHeight)
                  styleMask:NSWindowStyleMaskTitled |
                            NSWindowStyleMaskFullSizeContentView |
                            NSWindowStyleMaskNonactivatingPanel
                    backing:NSBackingStoreBuffered
                      defer:NO];
    [_panel setLevel:NSFloatingWindowLevel];
    [_panel setTitlebarAppearsTransparent:YES];
    [_panel setTitleVisibility:NSWindowTitleHidden];
    [_panel setMovableByWindowBackground:YES];
    [_panel setHidesOnDeactivate:YES];

    [_panel setBackgroundColor:THEME_HEX(THEME_COLOR_BG)];

    NSView *contentView = [_panel contentView];

    // Search field
    _searchField = [[NSTextField alloc]
        initWithFrame:NSMakeRect(12, panelHeight - 48, panelWidth - 24, 32)];
    [_searchField setFont:[NSFont systemFontOfSize:THEME_FONT_SIZE_SEARCH]];
    [_searchField setTextColor:THEME_HEX(THEME_COLOR_FG)];
    [_searchField setBackgroundColor:THEME_HEX(THEME_COLOR_SEL)];
    [_searchField setFocusRingType:NSFocusRingTypeNone];
    [_searchField setBordered:NO];
    [_searchField setBezeled:YES];
    [_searchField setBezelStyle:NSTextFieldRoundedBezel];
    [_searchField setPlaceholderString:@"Search..."];
    [_searchField setDelegate:self];
    [contentView addSubview:_searchField];

    // Scroll view + table view
    _scrollView = [[NSScrollView alloc]
        initWithFrame:NSMakeRect(12, 12, panelWidth - 24, panelHeight - 68)];
    [_scrollView setHasVerticalScroller:YES];
    [_scrollView setScrollerStyle:NSScrollerStyleOverlay];
    [_scrollView setDrawsBackground:NO];
    [_scrollView setBorderType:NSNoBorder];

    _tableView = [[NSTableView alloc] initWithFrame:[_scrollView bounds]];
    NSTableColumn *col = [[NSTableColumn alloc]
        initWithIdentifier:@"name"];
    [col setWidth:panelWidth - 40];
    [_tableView addTableColumn:col];
    [_tableView setHeaderView:nil];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setRowHeight:28];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_tableView setSelectionHighlightStyle:
        NSTableViewSelectionHighlightStyleRegular];
    [_tableView setIntercellSpacing:NSMakeSize(0, 2)];

    [_scrollView setDocumentView:_tableView];
    [contentView addSubview:_scrollView];

    // Keyboard event monitor
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown
                                          handler:^NSEvent *(NSEvent *event) {
        // Forward Cmd shortcuts to the first responder
        if ([event modifierFlags] & NSEventModifierFlagCommand) {
            NSString *chars = [event charactersIgnoringModifiers];
            if ([chars isEqualToString:@"a"]) {
                [self->_searchField selectText:nil];
                return nil;
            }
            if ([chars isEqualToString:@"c"]) {
                [NSApp sendAction:@selector(copy:) to:nil from:nil];
                return nil;
            }
            if ([chars isEqualToString:@"v"]) {
                [NSApp sendAction:@selector(paste:) to:nil from:nil];
                return nil;
            }
            if ([chars isEqualToString:@"x"]) {
                [NSApp sendAction:@selector(cut:) to:nil from:nil];
                return nil;
            }
        }
        switch ([event keyCode]) {
            case 36: // Return
                [self selectItem];
                return nil;
            case 53: // Escape
                [self cancel];
                return nil;
            case 125: { // Down arrow
                NSInteger row = [self->_tableView selectedRow];
                NSInteger count = [self->_filteredItems count];
                if (row < count - 1) {
                    [self->_tableView selectRowIndexes:
                        [NSIndexSet indexSetWithIndex:row + 1]
                                  byExtendingSelection:NO];
                    [self->_tableView scrollRowToVisible:row + 1];
                }
                return nil;
            }
            case 126: { // Up arrow
                NSInteger row = [self->_tableView selectedRow];
                if (row > 0) {
                    [self->_tableView selectRowIndexes:
                        [NSIndexSet indexSetWithIndex:row - 1]
                                  byExtendingSelection:NO];
                    [self->_tableView scrollRowToVisible:row - 1];
                }
                return nil;
            }
            default:
                return event;
        }
    }];
}

// ---------------------------------------------------------------------------
// Show / hide
// ---------------------------------------------------------------------------

- (void)show {
    _previousApp = [[NSWorkspace sharedWorkspace] frontmostApplication];
    [_searchField setStringValue:@""];
    _filteredItems = [_items mutableCopy];
    _scoredItems = nil;
    [_tableView reloadData];
    if ([_filteredItems count] > 0) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
    }
    [_panel makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    [_panel makeFirstResponder:_searchField];
}

- (void)hide {
    [_panel orderOut:nil];
}

- (void)restoreFocus {
    if (_previousApp) {
        [_previousApp activateWithOptions:NSApplicationActivateAllWindows];
        _previousApp = nil;
    }
}

- (void)showDrun:(int)fd {
    // Cancel current interaction if panel is already showing
    if (_clientFd >= 0) {
        write(_clientFd, RESP_CANCELLED, strlen(RESP_CANCELLED));
        close(_clientFd);
    }
    _clientFd = fd;
    _mode = MODE_DRUN;
    [self show];
}

// ---------------------------------------------------------------------------
// Selection / cancellation
// ---------------------------------------------------------------------------

- (void)selectItem {
    NSInteger row = [_tableView selectedRow];
    if (row < 0 || row >= (NSInteger)[_filteredItems count]) {
        [self cancel];
        return;
    }
    NSString *selected = _filteredItems[row];

    if (_serverMode) {
        // Server mode: open app and notify client
        NSString *path = _appPaths[selected];
        if (path) {
            [[NSWorkspace sharedWorkspace] openURL:
                [NSURL fileURLWithPath:path]];
        }
        if (_clientFd >= 0) {
            write(_clientFd, RESP_SELECTED, strlen(RESP_SELECTED));
            close(_clientFd);
            _clientFd = -1;
        }
        [self hide];
        [self restoreFocus];
    } else {
        // One-shot mode
        if (_mode == MODE_DRUN) {
            NSString *path = _appPaths[selected];
            if (path) {
                [[NSWorkspace sharedWorkspace] openURL:
                    [NSURL fileURLWithPath:path]];
            }
        } else {
            printf("%s\n", [selected UTF8String]);
        }
        [self restoreFocus];
        exit(0);
    }
}

- (void)cancel {
    if (_serverMode) {
        if (_clientFd >= 0) {
            write(_clientFd, RESP_CANCELLED, strlen(RESP_CANCELLED));
            close(_clientFd);
            _clientFd = -1;
        }
        [self hide];
        [self restoreFocus];
    } else {
        [self restoreFocus];
        exit(0);
    }
}

- (void)applicationDidResignActive:(NSNotification *)notification {
    // Only cancel if the panel is visible (avoid cancelling when server is idle)
    if ([_panel isVisible]) {
        [self cancel];
    }
}

// ---------------------------------------------------------------------------
// Filtering (NSTextFieldDelegate)
// ---------------------------------------------------------------------------

- (void)controlTextDidChange:(NSNotification *)notification {
    NSString *query = [_searchField stringValue];
    if ([query length] == 0) {
        _filteredItems = [_items mutableCopy];
        _scoredItems = nil;
    } else {
        NSMutableArray<ScoredItem *> *scored = [NSMutableArray new];
        for (NSString *item in _items) {
            FuzzyResult r = fuzzyMatch(query, item);
            if (r.match) {
                ScoredItem *si = [ScoredItem new];
                si.text = item;
                si.score = r.score;
                NSMutableArray *indices = [NSMutableArray new];
                for (NSUInteger k = 0; k < r.matchCount; k++) {
                    [indices addObject:@(r.matchIndices[k])];
                }
                si.matchIndices = indices;
                [scored addObject:si];
            }
        }
        [scored sortUsingComparator:
            ^NSComparisonResult(ScoredItem *a, ScoredItem *b) {
                if (a.score > b.score) return NSOrderedAscending;
                if (a.score < b.score) return NSOrderedDescending;
                return [a.text compare:b.text];
            }];
        _scoredItems = scored;
        _filteredItems = [NSMutableArray new];
        for (ScoredItem *si in scored) {
            [_filteredItems addObject:si.text];
        }
    }
    [_tableView reloadData];
    if ([_filteredItems count] > 0) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
                byExtendingSelection:NO];
        [_tableView scrollRowToVisible:0];
    }
}

// ---------------------------------------------------------------------------
// NSTableViewDataSource
// ---------------------------------------------------------------------------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_filteredItems count];
}

// ---------------------------------------------------------------------------
// NSTableViewDelegate
// ---------------------------------------------------------------------------

- (NSView *)tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row {
    NSView *container = [[NSView alloc]
        initWithFrame:NSMakeRect(0, 0, tableColumn.width, 28)];

    NSString *text = _filteredItems[row];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
        initWithString:text
            attributes:@{
                NSForegroundColorAttributeName: THEME_HEX(THEME_COLOR_FG),
                NSFontAttributeName: [NSFont systemFontOfSize:THEME_FONT_SIZE_LIST]
            }];

    if (_scoredItems && row < (NSInteger)[_scoredItems count]) {
        for (NSNumber *idx in _scoredItems[row].matchIndices) {
            NSRange range = NSMakeRange([idx unsignedIntegerValue], 1);
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:THEME_HEX(THEME_COLOR_ACCENT)
                            range:range];
            [attrStr addAttribute:NSUnderlineStyleAttributeName
                            value:@(NSUnderlineStyleSingle)
                            range:range];
        }
    }

    NSTextField *cell = [NSTextField labelWithAttributedString:attrStr];
    [cell setDrawsBackground:NO];
    [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
    [container addSubview:cell];
    [[cell.centerYAnchor constraintEqualToAnchor:container.centerYAnchor]
        setActive:YES];
    [[cell.leadingAnchor constraintEqualToAnchor:container.leadingAnchor
                                        constant:8] setActive:YES];
    [[cell.trailingAnchor constraintEqualToAnchor:container.trailingAnchor
                                         constant:-8] setActive:YES];
    return container;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView
                rowViewForRow:(NSInteger)row {
    return [[MenuRowView alloc] init];
}

@end
