//
//  ManagedObjectSenTestCase.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 22.06.11.
//  Copyright 2011 -. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface ManagedObjectSenTestCase : SenTestCase {
	NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
}

@end
