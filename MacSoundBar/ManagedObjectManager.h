//
//  ManagedObjectManager.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 02.08.11.
//  Copyright 2011 -. All rights reserved.
//


@interface ManagedObjectManager : NSObject {

    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    
}

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(BOOL)save:(NSError **)error;

@end
