//
//  SoundManagerTest.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 05.06.11.
//  Copyright 2011 -. All rights reserved.
//

#import "SoundManagerTest.h"
#import "SoundManager.h"

@implementation SoundManagerTest

- (void)testFindByName {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];
    NSData *data = [NSData dataWithBytes:@"test" length:4];
    [soundManager addSound:@"name1" withData:data];
    
    Sound *sound = [soundManager findByName:@"gits net"];
    STAssertNil(sound, @"sound must not be nil");
    
    sound = [soundManager findByName:@"name1"];
    STAssertNotNil(sound, @"sound must not be nil");
    STAssertEquals(sound.index, (NSInteger) 1, @"index must be 1");
    STAssertEquals(sound.name, @"name1", @"name must be name1");
    STAssertEquals(sound.data, data, @"data must be 'test'");
}

- (void)testFindAll {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];    
    [soundManager addSound:@"name1" withData:nil];
    [soundManager addSound:@"name2" withData:nil];
    [soundManager addSound:@"name3" withData:nil];
    NSArray *sounds = [soundManager findAll];
    STAssertEquals([sounds count], (NSUInteger) 3, @"size must be 3");
}

- (void)testGetCount {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];
    STAssertEquals([soundManager getCount], (NSInteger) 0, @"count must be 0");
    
    [soundManager addSound:@"name1" withData:nil];
    STAssertEquals([soundManager getCount], (NSInteger) 1, @"count must be 1");
    
    [soundManager addSound:@"name2" withData:nil];
    STAssertEquals([soundManager getCount], (NSInteger) 2, @"count must be 2");
    
    [soundManager deleteByName:@"name1"];
    STAssertEquals([soundManager getCount], (NSInteger) 1, @"count must be 1");
}

- (void)assertSounds:(NSArray *)sounds withNames:(NSArray *)names {
    STAssertEquals([sounds count], [names count], @"size of sounds and names must be equal");    
    for (int i=0; i<[sounds count]; i++) {
        Sound *sound = [sounds objectAtIndex:i];
        STAssertEquals(sound.index, (NSInteger) (i+1), @"index must be %d", i+1);
        STAssertEquals(sound.name, [names objectAtIndex:i], @"name must be %@", [names objectAtIndex:i]);
    }
}

- (void)testAddSound {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];    
    [soundManager addSound:@"name1" withData:nil];
    [soundManager addSound:@"name2" withData:nil];
    [soundManager addSound:@"name3" withData:nil];
    NSArray *names = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
    [self assertSounds:[soundManager findAll] withNames:names];
    
    NSData *data = [NSData dataWithBytes:@"test" length:4];
    [soundManager addSound:@"name2" withData:data];
    names = [NSArray arrayWithObjects:@"name1", @"name2", @"name3", nil];
    [self assertSounds:[soundManager findAll] withNames:names];
    Sound *sound = [soundManager findByName:@"name2"];
    STAssertEquals(sound.data, data, @"data must be 'test'");
}

-(void)testMoveSound {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];
    [soundManager addSound:@"name1" withData:nil];
    [soundManager addSound:@"name2" withData:nil];
    [soundManager addSound:@"name3" withData:nil];
    [soundManager addSound:@"name4" withData:nil];

    [soundManager moveSound:@"name2" toIndex:3];
    NSArray *names = [NSArray arrayWithObjects:@"name1", @"name3", @"name2", @"name4", nil];
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name1" toIndex:4];
    names = [NSArray arrayWithObjects:@"name3", @"name2", @"name4", @"name1", nil];
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name2" toIndex:1];    
    names = [NSArray arrayWithObjects:@"name2", @"name3", @"name4", @"name1", nil];
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name4" toIndex:1];    
    names = [NSArray arrayWithObjects:@"name4", @"name2", @"name3", @"name1", nil];
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name2" toIndex:0];    
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name2" toIndex:2];    
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"name2" toIndex:5];    
    [self assertSounds:[soundManager findAll] withNames:names];    

    [soundManager moveSound:@"gibts nicht" toIndex:2];    
    [self assertSounds:[soundManager findAll] withNames:names];    

}

- (void)testDeleteByName {
    SoundManager *soundManager = [[SoundManager alloc] initWithManagedObjectContext:ctx];
    [soundManager addSound:@"name1" withData:nil];
    [soundManager addSound:@"name2" withData:nil];
    [soundManager addSound:@"name3" withData:nil];
    [soundManager addSound:@"name4" withData:nil];
    
    [soundManager deleteByName:@"name2"];
    NSArray *sounds = [soundManager findAll];
    NSArray *names = [NSArray arrayWithObjects:@"name1", @"name3", @"name4", nil];
    [self assertSounds:sounds withNames:names];
}



@end
