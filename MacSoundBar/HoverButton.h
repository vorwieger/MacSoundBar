//
//  HoverButton.h
//  HoverButton
//

#import <Cocoa/Cocoa.h>


@interface HoverButton : NSButton {
	NSTrackingArea *trackingArea;
}

@property(strong) NSImage *normalImage;
@property(strong) NSImage *hoverImage;

@end
