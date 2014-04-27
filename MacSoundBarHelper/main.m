//
//  main.m
//  MacSoundBarHelper
//
//  Created by Peter Vorwieger on 06.08.11.
//  Copyright 2011 -. All rights reserved.
//

#import "MacSoundBarHelper.h"

int main (int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];        
        pid_t parentPid = (pid_t)[args integerForKey:@"parentPid"];
        NSLog(@"MacSoundBarHelper started. (parentPid=%d)", parentPid);
        id helper;
        helper = [[MacSoundBarHelper alloc] initWithParentPid:parentPid];
        
        // run main event loop
        [[NSApplication sharedApplication] run];
    }
    return 0;
}

