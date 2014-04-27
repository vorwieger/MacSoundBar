//
//  MacSoundBarHelper.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 07.08.11.
//  Copyright 2011 -. All rights reserved.
//



@interface MacSoundBarHelper : NSObject {

    pid_t parentPid;

}

@property pid_t parentPid;

- (id)initWithParentPid:(pid_t) pid;

@end
