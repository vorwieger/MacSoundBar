//
//  ManagedObjectSenTestCase.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 22.06.11.
//  Copyright 2011 -. All rights reserved.
//

#import "ManagedObjectSenTestCase.h"


@implementation ManagedObjectSenTestCase

- (void)setUp {
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
}

- (void)tearDown {
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
}


@end