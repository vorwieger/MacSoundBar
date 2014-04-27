//
//  SoundItemView.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 10.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundItemView.h"
#import "HoverButton.h"

@implementation SoundItemView

@synthesize inDrag;
@synthesize deleteButton;

NSString* const DRAGGED_TYPE = @"MacSoundBar";

- (id)initWithSizeForLabel:(NSString*)label {
    self = [super initWithSizeForLabel:label];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObject:DRAGGED_TYPE]];
        self.deleteButton = [[HoverButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
        [self.deleteButton setBordered:NO];
        NSImage *image = [NSImage imageNamed:@"cross1.png"];
        NSImage *hover = [NSImage imageNamed:@"cross2.png"];        
        [self.deleteButton setImage:image];
        [(HoverButton*)self.deleteButton setHoverImage:hover];
        
        [self.deleteButton setTarget:self];
        [self.deleteButton setAction:@selector(delete:)];
        [self.deleteButton setHidden:NO];        
        [self addSubview:self.deleteButton];
        [self setNeedsDisplay:YES];
    }    
    return self;
}


- (void)delete:(id)sender {
    NSMenuItem *item = [self enclosingMenuItem];
    [item.target deleteItem:item.title];
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    inDrag = YES;
    [self setNeedsDisplay:YES];
    return NSDragOperationEvery;
}

-(void)draggingExited:(id<NSDraggingInfo>)sender {
    inDrag = NO;
    [self setNeedsDisplay:YES];
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    inDrag = NO;
    [self setNeedsDisplay:YES];
    return YES;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    SoundItemView *source = [sender draggingSource];
    NSMenuItem *sourceItem = [source enclosingMenuItem];
    NSMenuItem *targetItem = [self enclosingMenuItem];
    NSInteger sourceIndex = [[sourceItem menu] indexOfItem:sourceItem];
    NSInteger targetIndex = [[targetItem menu] indexOfItem:targetItem];
    [sourceItem.target moveItem:sourceItem.title toIndex:targetIndex>sourceIndex?targetIndex:targetIndex+1];
    return YES;
}

-(NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag {
    return flag?NSDragOperationMove:NSDragOperationNone;
}

-(void)mouseDragged:(NSEvent *)theEvent {
    NSMenuItem *item = [self enclosingMenuItem];
    
    //TODO besser machen
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject: [NSFont menuFontOfSize:14.0] forKey: NSFontAttributeName];
    CGSize size = [item.title sizeWithAttributes:attributes];
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus]; 
    [item.title drawAtPoint:NSMakePoint(0.0, 0.0) withAttributes:attributes];
    [image unlockFocus];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item.title];
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [pboard declareTypes:[NSArray arrayWithObject:DRAGGED_TYPE] owner:self];
    [pboard setData:data forType:DRAGGED_TYPE];
    
    [self dragImage:image at:NSMakePoint(20.0, 0.0) offset:NSZeroSize event:theEvent
         pasteboard:pboard source:self slideBack:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self.deleteButton setHidden:![[self enclosingMenuItem] isHighlighted]];
    if (inDrag) {
        [[NSColor selectedMenuItemColor] set];
        [NSBezierPath fillRect:NSMakeRect(10, 0, [self bounds].size.width - 20, 2)];   
    }
}

@end
