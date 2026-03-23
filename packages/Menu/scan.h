#ifndef MENU_SCAN_H
#define MENU_SCAN_H

#import <Foundation/Foundation.h>

void scanApps(NSMutableArray<NSString *> **outItems,
              NSMutableDictionary<NSString *, NSString *> **outPaths);

#endif
