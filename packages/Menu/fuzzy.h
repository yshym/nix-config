#ifndef MENU_FUZZY_H
#define MENU_FUZZY_H

#import <Foundation/Foundation.h>

typedef struct {
    BOOL match;
    int score;
    NSUInteger matchIndices[256];
    NSUInteger matchCount;
} FuzzyResult;

FuzzyResult fuzzyMatch(NSString *query, NSString *item);

@interface ScoredItem : NSObject
@property (strong) NSString *text;
@property int score;
@property (strong) NSArray<NSNumber *> *matchIndices;
@end

#endif
