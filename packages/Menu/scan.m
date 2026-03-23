#import "scan.h"

void scanApps(NSMutableArray<NSString *> **outItems,
              NSMutableDictionary<NSString *, NSString *> **outPaths) {
    NSArray *dirs = @[
        @"/System/Applications",
        @"/System/Applications/Utilities",
        @"/System/Library/CoreServices",
        @"/Applications",
        @"/Applications/Utilities",
        [NSHomeDirectory() stringByAppendingPathComponent:@"Applications/Nix"]
    ];
    NSMutableArray *items = [NSMutableArray new];
    NSMutableDictionary *paths = [NSMutableDictionary new];
    NSFileManager *fm = [NSFileManager defaultManager];

    for (NSString *dir in dirs) {
        BOOL isDir;
        if (![fm fileExistsAtPath:dir isDirectory:&isDir] || !isDir) continue;
        NSArray *contents = [fm contentsOfDirectoryAtPath:dir error:nil];
        for (NSString *entry in contents) {
            if (![entry hasSuffix:@".app"]) continue;
            NSString *name = [entry stringByDeletingPathExtension];
            NSString *path = [dir stringByAppendingPathComponent:entry];
            // Skip duplicates (first found wins)
            if (!paths[name]) {
                paths[name] = path;
                [items addObject:name];
            }
        }
    }
    [items sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    *outItems = items;
    *outPaths = paths;
}
