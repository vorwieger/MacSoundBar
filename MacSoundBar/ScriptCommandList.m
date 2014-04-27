//
//  MacSoundBarSciptCommand.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 04.06.12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "ScriptCommandList.h"
#import "MacSoundBarAppDelegate.h"

@implementation ScriptCommandList

-(id)performDefaultImplementation {
    MacSoundBarAppDelegate *app = (MacSoundBarAppDelegate*) [NSApplication sharedApplication].delegate;
    NSArray *sounds = [app listAll];
    NSArray *names = [sounds valueForKeyPath:@"name"];
    return [names componentsJoinedByString:@"\n"];
}

@end
