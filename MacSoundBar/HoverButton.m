//
//  HoverButton.m
//  HoverButton
//

#import "HoverButton.h"


@implementation HoverButton

@synthesize normalImage, hoverImage;

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (trackingArea) {
		[self removeTrackingArea:trackingArea];
	}
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)setImage:(NSImage *)image {
    [super setImage:image];
    self.normalImage = image;
}

- (void)mouseEntered:(NSEvent *)event {
    if (self.hoverImage) {
        [super setImage:self.hoverImage];
    } else {
        [super setImage:self.normalImage];
    }
}

- (void)mouseExited:(NSEvent *)event {
	[super setImage:self.normalImage];
}

@end
