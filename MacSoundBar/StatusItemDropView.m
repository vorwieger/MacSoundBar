
#import "StatusItemDropView.h"

@interface StatusItemDropView(Private)
- (void)_resizeToFitIfNeeded;
@end

@implementation StatusItemDropView

@synthesize doesHighlight;
@synthesize image, alternateImage;
@synthesize delegate;

+ (StatusItemDropView *)viewWithStatusItem:(NSStatusItem *)statusItem {
	return [[StatusItemDropView alloc] initWithStatusItem:statusItem];
}

- (id)initWithStatusItem:(NSStatusItem *)statusItem {
    CGFloat length = ([statusItem length] == NSVariableStatusItemLength) ? 32.0f : [statusItem length];
	NSRect frame = NSMakeRect(0, 0, length, [[NSStatusBar systemStatusBar] thickness]);
	if((self = [self initWithFrame:frame]))	{
		parentStatusItem = statusItem;
		[parentStatusItem addObserver:self forKeyPath:@"length" options:NSKeyValueObservingOptionNew context:nil];
		self.doesHighlight = NO;
		self.image = nil;
        self.image = nil;
		self.delegate = nil;
	}
	return self;
}

- (void)dealloc {
	[parentStatusItem removeObserver:self forKeyPath:@"length"];
	self.delegate = nil;
	parentStatusItem = nil; // we only had weak reference
}

#pragma mark -

- (void)setImage:(NSImage *)newImage {
	if (newImage != image) {
		image = [newImage copy];
		[self setNeedsDisplay:YES];
	}
}

- (void)setAlternateImage:(NSImage *)newImage {
	if (newImage != alternateImage) {
		alternateImage = [newImage copy];
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -

- (void)mouseDown:(NSEvent *)theEvent {
    highlighted = YES;
    [self setNeedsDisplay:YES];
	[parentStatusItem popUpStatusItemMenu:[parentStatusItem menu]];
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    highlighted = NO;
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark NSMenu Delegate

- (void)menuWillOpen:(NSMenu *)menu {
	highlighted = YES;
	[self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
	highlighted = NO;
	[self setNeedsDisplay:YES];	
}

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect {
    CGFloat x =  NSMidX([self bounds]) - ([self.image size].width / 2);
    CGFloat y =  NSMidY([self bounds]) - ([self.image size].height / 2);
   	NSRect centeredRect = NSMakeRect(x, y, [self.image size].width, [self.image size].height);
	if(highlighted && [self doesHighlight])	{
		[[NSColor selectedMenuItemColor] set];
		[NSBezierPath fillRect:[self bounds]];
		[self.alternateImage drawInRect:centeredRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	} else {
		[self.image drawInRect:centeredRect fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    }
}

#pragma mark -
#pragma mark NSDraggingDestination protocol

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	return [delegate statusItemView:self draggingEntered:sender];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
	[delegate statusItemView:self draggingExited:sender];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {	
	return [delegate statusItemView:self prepareForDragOperation:sender];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	return [delegate statusItemView:self performDragOperation:sender];
}

@end
