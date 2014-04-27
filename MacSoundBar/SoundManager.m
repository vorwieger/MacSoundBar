//
//  SoundManager.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

@interface SoundManager()

- (NSFetchRequest *)newFetchRequest;

@end


@implementation SoundManager

@synthesize context;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *) aContext {
    self = [super init];
    if (self) {
        self.context = aContext;
    }
    return self;
}

-(BOOL)playSoundAtIndex:(NSInteger)index {
    Sound *sound = [self findByIndex:index];
    if (sound) {
        NSLog(@"play sound: %@", sound.name);
        NSSound *nsSound = [[NSSound alloc] initWithData:sound.data];
        [nsSound setDelegate:self];
        [nsSound play];
        return YES;
    }
    return NO;
}

-(void)sound:(NSSound *)sound didFinishPlaying:(BOOL)aBool {
//    NSLog(@"didFinishPlaying: %@", sound);
}

- (NSFetchRequest *)newFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sound" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    return fetchRequest;
}

- (Sound *)findByContainedName:(NSString *)name {
    NSFetchRequest *fetchRequest = [self newFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name contains[c] %@", name]];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
    return fetchedObjects.count>0?[fetchedObjects objectAtIndex:0]:nil;
}

- (Sound *)findByName:(NSString *)name {
    NSFetchRequest *fetchRequest = [self newFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name=%@", name]];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
    return [fetchedObjects lastObject];
}

- (Sound *)findByIndex:(NSInteger)index {
    NSFetchRequest *fetchRequest = [self newFetchRequest];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index=%ld", index]];
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
    return [fetchedObjects lastObject];
}

- (NSArray *)findAll {
    NSFetchRequest *fetchRequest = [self newFetchRequest];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    return [self.context executeFetchRequest:fetchRequest error:NULL];
}

- (NSInteger)getCount {
    NSFetchRequest *fetchRequest = [self newFetchRequest];
    return [self.context countForFetchRequest:fetchRequest error:NULL];
}

- (void)addSound:(NSString *)aName withData:(NSData *)aData {
    Sound *sound = [self findByName:aName];
    if (sound) {
        sound.data = aData;
    } else {
        sound = [NSEntityDescription insertNewObjectForEntityForName:@"Sound" inManagedObjectContext:self.context];    
        sound.name = aName;
        sound.data = aData;
        sound.index = [self getCount];
    }
}

- (void)moveSound:(NSString *)name toIndex:(NSInteger) index {
    Sound *sound = [self findByName:name];
    if (!sound || index < 1 || index > [self getCount]) return;
    if (index < sound.index) {
        NSFetchRequest *fetchRequest = [self newFetchRequest];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index >= %ld and index < %ld", index, sound.index]];
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
        for (Sound *s in fetchedObjects) {
            s.index = s.index + 1;
        }
        sound.index = index;
    } else if (sound.index < index) {
        NSFetchRequest *fetchRequest = [self newFetchRequest];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index > %ld and index <= %ld", sound.index, index]];
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
        for (Sound *s in fetchedObjects) {
            s.index = s.index - 1;
        }
        sound.index = index;
    }
}

- (void) deleteByName:(NSString *)name {
    Sound *sound = [self findByName:name];
    NSInteger index = sound.index;
    if (sound) {
        [self.context deleteObject:sound];
        NSFetchRequest *fetchRequest = [self newFetchRequest];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"index > %ld", index]];
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:NULL];
        for (Sound *s in fetchedObjects) {
            s.index = s.index - 1;
        }
    }
}

@end
