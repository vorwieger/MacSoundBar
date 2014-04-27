//
//  MacSoundBarHelper.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 07.08.11.
//  Copyright 2011 -. All rights reserved.
//

#import "MacSoundBarHelper.h"
#import <Carbon/Carbon.h>
#import "ManagedObjectManager.h"
#import "SoundManager.h"
#import "DDHotKeyCenter.h"

unsigned short getKey(int i);

unsigned short getKey(int i) {
    switch (i) {
        case 1:return kVK_F1;
        case 2:return kVK_F2;
        case 3:return kVK_F3;
        case 4:return kVK_F4;
        case 5:return kVK_F5;
        case 6:return kVK_F6;
        case 7:return kVK_F7;
        case 8:return kVK_F8;
        case 9:return kVK_F9;
        case 10:return kVK_F10;
        case 11:return kVK_F11;
        case 12:return kVK_F12;
        default:return 0;
    }
}

@implementation MacSoundBarHelper

@synthesize parentPid;

- (void)heartbeat:(NSTimer*)theTimer {
    if (parentPid) {
        NSRunningApplication *app = [NSRunningApplication runningApplicationWithProcessIdentifier:parentPid];
        if (!app) {
            NSLog(@"terminate");    
            [NSApp terminate:nil];
        } 
    }
}

- (id)initWithParentPid:(pid_t) pid {
    self = [super init];
    if (self) {
        self.parentPid = pid;        
        ManagedObjectManager *mom = [[ManagedObjectManager alloc] init];
        SoundManager *sm = [[SoundManager alloc] initWithManagedObjectContext:mom.managedObjectContext];
        DDHotKeyCenter *hotKeyCenter = [[DDHotKeyCenter alloc] init];
        for (int i=1; i<=12; i++) {
            [hotKeyCenter registerHotKeyWithKeyCode:getKey(i) modifierFlags:NSCommandKeyMask task:^(NSEvent *event) {
                if ([sm playSoundAtIndex:i]) {
                    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"play" object:@"MacSoundBarHelper" 
                            userInfo:nil deliverImmediately:YES];
                }
            }];
        }
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(heartbeat:) userInfo:nil repeats:YES];
    }
    return self;
}

@end
