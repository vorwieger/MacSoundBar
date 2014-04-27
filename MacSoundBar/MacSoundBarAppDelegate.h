//
//  MacSoundBarAppDelegate.h
//  MacSoundBar
//
//  Created by Peter Vorwieger on 09.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import <Quartz/Quartz.h>
#import "SoundItemView.h"
#import "ManagedObjectManager.h"
#import "SoundManager.h"

@interface MacSoundBarAppDelegate : NSObject <NSApplicationDelegate, SoundItemViewDelegate, NSAnimationDelegate, NSOpenSavePanelDelegate> {
@private
    NSMenu *statusMenu;
    NSStatusItem *statusItem;
    SoundManager *soundManager;
    ManagedObjectManager *mom;
    NSTask *_helperTask;
    NSImageView *star;
    CAKeyframeAnimation *flashStarAnimation;
    NSWindow *preferencesWindow;
    NSWindow *aboutWindow;
    NSTextField *versionLabel;
}
@property (strong) IBOutlet NSWindow *preferencesWindow;
@property (strong) IBOutlet NSWindow *aboutWindow;
@property (strong) IBOutlet NSTextField *versionLabel;

@property (strong) NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;
@property (strong) SoundManager *soundManager;
@property (strong) ManagedObjectManager *mom;
@property (strong, nonatomic) NSTask *helperTask;
@property (strong) IBOutlet NSImageView *star;
@property (strong) CAKeyframeAnimation *flashStarAnimation;

- (NSArray*)listAll;
- (void)refreshMenu;
- (void)openFile;
- (void)openPreferences:(id)sender;
- (void)openAbout:(id)sender;
- (void)terminate;
- (void)play:(id)sender;
- (void)playByName:(NSString *)name;
- (void)playByNotification:(NSNotification *)notification;
- (IBAction)saveAction:sender;

@end
