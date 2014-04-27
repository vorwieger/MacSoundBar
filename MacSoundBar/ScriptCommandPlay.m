//
//  MacSoundBarSciptCommand.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 04.06.12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "ScriptCommandPlay.h"

@implementation ScriptCommandPlay

-(id)performDefaultImplementation {

    NSDictionary *args = [self evaluatedArguments];
    NSString *soundToPlay = @"";
    if(args.count) {
        soundToPlay = [args valueForKey:@""];    // get the direct argument
    } else {
        [self setScriptErrorNumber:-50];
        [self setScriptErrorString:@"Parameter Error: Specify a Sound you wanna play."];
    }

    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:soundToPlay, @"sound", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"play" object:self userInfo:info];
    return nil;
}

@end
