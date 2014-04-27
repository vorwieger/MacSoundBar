//
//  SimpleItemView.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 01.07.11.
//  Copyright 2011 -. All rights reserved.
//

#import "SimpleItemView.h"


@implementation SimpleItemView

- (id)initWithSizeForLabel:(NSString*)label {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject: [NSFont menuFontOfSize:14.0] forKey: NSFontAttributeName];
    CGSize size = [label sizeWithAttributes:attributes];
    self = [super initWithFrame:NSMakeRect(0, 0, size.width + 110, 20)];
    if (self) {
        [self setAutoresizingMask:NSViewWidthSizable];
    }    
    return self;
}


- (void)viewDidMoveToWindow {
    [[self window] becomeKeyWindow];
}

-(BOOL)acceptsFirstResponder {
    return YES; 
}

-(void)keyDown:(NSEvent *)theEvent {
//    NSLog(@"keyDown: %@", theEvent);
    if ([theEvent keyCode]==36) {
        [self mouseUp:theEvent];
    } else {
        [super keyDown:theEvent];
    }
}

-(void)mouseUp:(NSEvent *)theEvent {
    NSMenuItem *item= [self enclosingMenuItem];
    NSMenu* menu = [item menu];
    [menu cancelTrackingWithoutAnimation];
    [menu performActionForItemAtIndex:[menu indexOfItem:item]];
    
    // hack to reset highlighted menu item state
    NSArray *items = [menu itemArray];
    [menu removeAllItems];
    for (NSMenuItem *item in items) {
        [menu addItem:item];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject: [NSFont menuFontOfSize:14.0] forKey: NSFontAttributeName];
    NSMenuItem *menuItem = [self enclosingMenuItem];
    
    if ([menuItem isHighlighted]) {
        [[NSColor selectedMenuItemColor] set];
        [NSBezierPath fillRect:[self bounds]];
        [attributes setObject: [NSColor selectedMenuItemTextColor] forKey:NSForegroundColorAttributeName];
    }    
    
	[menuItem.title drawAtPoint:NSMakePoint(20.0, 2.0) withAttributes:attributes];    
    
    NSString *keyEquivalent = [[self enclosingMenuItem] keyEquivalent];
    if (keyEquivalent.length > 0) {
        NSUInteger modifier = [[self enclosingMenuItem] keyEquivalentModifierMask];
        NSString *key = @"";
        if (modifier & NSControlKeyMask) {
            key = [key stringByAppendingString:@"⌃"];
        }
        if (modifier & NSAlternateKeyMask) {
            key = [key stringByAppendingString:@"⌥"];
        }
        if (modifier & NSShiftKeyMask) {
            key = [key stringByAppendingString:@"⇧"];
        }
        if (modifier & NSCommandKeyMask) {
            key = [key stringByAppendingString:@"⌘"];
        }
        key = [key stringByAppendingFormat:@"%@",keyEquivalent];
        CGSize size = [key sizeWithAttributes:attributes];
        [key drawAtPoint:NSMakePoint(self.bounds.size.width - size.width - 10, 2.0) withAttributes:attributes];
    }
}

@end
