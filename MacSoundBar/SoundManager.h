//
//  SoundManager.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sound.h"


@interface SoundManager : NSObject <NSSoundDelegate> {
}

@property (nonatomic, strong) NSManagedObjectContext* context;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)aContext;
- (NSArray *)findAll;
- (Sound *)findByName:(NSString *)name;
- (Sound *)findByContainedName:(NSString *)name;
- (Sound *)findByIndex:(NSInteger)index;
- (void)addSound:(NSString *)aName withData:(NSData *)aData;
- (void)moveSound:(NSString *)name toIndex:(NSInteger) index;
- (void)deleteByName:(NSString *)name;
- (NSInteger)getCount;

- (BOOL)playSoundAtIndex:(NSInteger)index;

@end
