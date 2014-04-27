//
//  SoundItemView.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 10.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleItemView.h"

@class SoundItemView;

@protocol SoundItemViewDelegate
- (void)deleteItem:(NSString *)name;
- (void)moveItem:(NSString *)name toIndex:(NSInteger)index;
@end


@interface SoundItemView : SimpleItemView {
@private
}

@property (assign) BOOL inDrag;
@property (nonatomic, strong) NSButton *deleteButton;

@end
