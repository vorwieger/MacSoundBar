//
//  Sound.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 21.05.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"


@implementation Sound
@dynamic name;
@dynamic data;

- (NSInteger)index {
    [self willAccessValueForKey:@"index"];
    NSInteger i = index;
    [self didAccessValueForKey:@"index"];
    return i;
}

- (void)setIndex:(NSInteger)newIndex {
    [self willChangeValueForKey:@"index"];
    index = newIndex;
    [self didChangeValueForKey:@"index"];
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@"index"]) {
        self.index = 0;
    } else {
        [super setNilValueForKey:key];
    }
}

@end
