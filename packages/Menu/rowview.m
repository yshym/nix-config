#import "rowview.h"
#import "theme.h"

@implementation MenuRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    [THEME_HEX(THEME_COLOR_SEL) setFill];
    NSRectFill(self.bounds);
}

@end
