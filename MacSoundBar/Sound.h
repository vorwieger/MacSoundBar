//
//  Sound.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 21.05.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sound : NSManagedObject {

    NSInteger index;

}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *data;

@end
