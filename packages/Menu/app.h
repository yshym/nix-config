#ifndef MENU_APP_H
#define MENU_APP_H

#import <Cocoa/Cocoa.h>
#import "fuzzy.h"

typedef enum { MODE_STDIN, MODE_DRUN } MenuMode;

@interface AppDelegate : NSObject <NSApplicationDelegate,
                                   NSTableViewDataSource,
                                   NSTableViewDelegate,
                                   NSTextFieldDelegate>

@property (strong) NSPanel *panel;
@property (strong) NSTextField *searchField;
@property (strong) NSTableView *tableView;
@property (strong) NSScrollView *scrollView;
@property (strong) NSMutableArray<NSString *> *items;
@property (strong) NSMutableArray<NSString *> *filteredItems;
@property (strong) NSMutableArray<ScoredItem *> *scoredItems;
@property (strong) NSMutableDictionary<NSString *, NSString *> *appPaths;
@property MenuMode mode;
@property BOOL serverMode;
@property int clientFd;
@property (strong) NSRunningApplication *previousApp;
@property NSUInteger scrollGeneration;

// One-shot mode
- (void)setupWithItems:(NSMutableArray<NSString *> *)items
                  mode:(MenuMode)mode
              appPaths:(NSMutableDictionary<NSString *, NSString *> *)paths;

// Server mode
- (void)showDrun:(int)fd;
- (void)reloadApps;

// Shared
- (void)setupPanel;
- (void)show;

@end

#endif
