
#import "NSStatusItem+StatusItemDropView.h"
#import "StatusItemDropView.h"


@implementation NSStatusItem(StatusItemDropView)

- (void)setupView {
	StatusItemDropView *view = [StatusItemDropView viewWithStatusItem:self];
    [self setView:view];
	
	// view becomes delegate for highlighting purposes, this isn't ideal for all cases
	[[self menu] setDelegate:view];
}

- (void)registerForDraggedTypes:(NSArray *)types {
    [[self view] registerForDraggedTypes:types];
}

- (NSRect)frame {
	return [[[self view] window] frame];
}

- (void)setDelegate:(id)delegate {
	if([[self view] respondsToSelector:@selector(setDelegate:)])
		[(StatusItemDropView *)[self view] setDelegate:delegate];
}

#pragma mark -
#pragma mark Overrides

// our view replaces all drawing/etc. of NSStatusItem so we forward any related changes on to it
// TODO: we should do method swizzling or something to not block original methods

- (void)setImage:(NSImage *)image {
	[(StatusItemDropView *)[self view] setImage:image];
}

- (void)setAlternateImage:(NSImage *)image {
	[(StatusItemDropView *)[self view] setAlternateImage:image];
}

- (void)setHighlightMode:(BOOL)highlightMode {
	[(StatusItemDropView *)[self view] setDoesHighlight:highlightMode];
}

@end
