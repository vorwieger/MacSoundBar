
#import <Cocoa/Cocoa.h>

@class StatusItemDropView;

@interface NSStatusItem(StatusItemDropView)

- (void)setupView;
- (void)registerForDraggedTypes:(NSArray *)types;

/**
 * Convenience method which gets the window frame for the custom NSStatusItem view
 */
- (NSRect)frame;

/**
 * Sets the view's delegate, convenience method 
 */
- (void)setDelegate:(id)delegate;

@end
