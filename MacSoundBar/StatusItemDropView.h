
#import <Cocoa/Cocoa.h>

@class StatusItemDropView;

@protocol StatusItemDropViewDelegate
- (NSDragOperation)statusItemView:(StatusItemDropView *)view draggingEntered:(id <NSDraggingInfo>)info;
- (void)statusItemView:(StatusItemDropView *)view draggingExited:(id <NSDraggingInfo>)info;
- (BOOL)statusItemView:(StatusItemDropView *)view prepareForDragOperation:(id <NSDraggingInfo>)info;
- (BOOL)statusItemView:(StatusItemDropView *)view performDragOperation:(id <NSDraggingInfo>)info;
@end

@interface StatusItemDropView : NSView<NSMenuDelegate> {
	NSStatusItem *parentStatusItem;
	NSMenu *menu;
	
	BOOL highlighted;
	BOOL doesHighlight;
	
	NSImage *image;
    NSImage *alternateImage;
	
	id<StatusItemDropViewDelegate> __unsafe_unretained delegate;
}

@property (assign, nonatomic) BOOL doesHighlight;
@property (copy, nonatomic) NSImage *image;
@property (copy, nonatomic) NSImage *alternateImage;
@property (assign, nonatomic) id<StatusItemDropViewDelegate> delegate;

+ (StatusItemDropView *)viewWithStatusItem:(NSStatusItem *)statusItem;
- (id)initWithStatusItem:(NSStatusItem *)statusItem;

@end
