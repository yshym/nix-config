#import "fuzzy.h"

FuzzyResult fuzzyMatch(NSString *query, NSString *item) {
    FuzzyResult result = {NO, 0, {0}, 0};
    NSString *lowerQuery = [query lowercaseString];
    NSString *lowerItem = [item lowercaseString];
    NSUInteger qLen = lowerQuery.length;
    NSUInteger iLen = lowerItem.length;
    if (qLen == 0) { result.match = YES; return result; }
    if (qLen > iLen) return result;

    NSUInteger qi = 0;
    int score = 0;
    BOOL prevMatched = NO;

    for (NSUInteger ii = 0; ii < iLen && qi < qLen; ii++) {
        unichar qc = [lowerQuery characterAtIndex:qi];
        unichar ic = [lowerItem characterAtIndex:ii];
        if (qc == ic) {
            result.matchIndices[result.matchCount++] = ii;
            score += 1;
            // Consecutive match bonus
            if (prevMatched) score += 3;
            // Start of string bonus
            if (ii == 0) score += 5;
            // Word boundary bonus (after space, hyphen, or camelCase)
            if (ii > 0) {
                unichar prev = [item characterAtIndex:ii - 1];
                if (prev == ' ' || prev == '-' || prev == '_')
                    score += 4;
                else if ([[NSCharacterSet uppercaseLetterCharacterSet]
                             characterIsMember:[item characterAtIndex:ii]] &&
                         [[NSCharacterSet lowercaseLetterCharacterSet]
                             characterIsMember:prev])
                    score += 3;
            }
            prevMatched = YES;
            qi++;
        } else {
            prevMatched = NO;
        }
    }

    if (qi == qLen) {
        result.match = YES;
        // Prefer shorter items
        result.score = score * 100 - (int)iLen;
    }
    return result;
}

@implementation ScoredItem
@end
