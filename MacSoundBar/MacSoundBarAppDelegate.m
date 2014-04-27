//
//  MacSoundBarAppDelegate.m
//  MacSoundBar
//
//  Created by Peter Vorwieger on 09.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MacSoundBarAppDelegate.h"
#import "SimpleItemView.h"
#import "SoundItemView.h"
#import "NSStatusItem+StatusItemDropView.h"
#import "StatusItemDropView.h"
#import "Sound.h"
#import "DDHotKeyCenter.h"
#import "SSZipArchive.h"

@interface MacSoundBarAppDelegate()
- (void)addFile:(NSURL *)url;
@end


@implementation MacSoundBarAppDelegate

//NSInteger const MODIFIER_MASK = 0;
NSInteger const MODIFIER_MASK = NSCommandKeyMask;
//NSInteger const MODIFIER_MASK = NSAlternateKeyMask+NSCommandKeyMask+NSShiftKeyMask+NSControlKeyMask;
NSInteger const MAX_KEYS = 12;

@synthesize preferencesWindow;
@synthesize aboutWindow;
@synthesize versionLabel;
@synthesize statusMenu;
@synthesize statusItem;
@synthesize soundManager;
@synthesize mom;
@synthesize helperTask;
@synthesize star;
@synthesize flashStarAnimation;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    pid_t pid = getpid();
    NSLog(@"MacSoundBar started. (pid=%d)", pid);
    self.helperTask = [[NSTask alloc] init];
    self.helperTask.launchPath = [[NSBundle mainBundle] pathForResource:@"MacSoundBarHelper" ofType:nil];
    self.helperTask.arguments=[NSArray arrayWithObjects:@"-parentPid", [NSString stringWithFormat:@"%d", pid ], nil];
    [self.helperTask launch];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
    [self.helperTask terminate];
}

-(void)awakeFromNib {
    self.versionLabel.stringValue = [@"Version " stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]];
    self.mom = [[ManagedObjectManager alloc] init];
    self.soundManager = [[SoundManager alloc] initWithManagedObjectContext:[self.mom managedObjectContext]];
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusMenu = [[NSMenu alloc] init];
	[self.statusItem setupView];
	[self.statusItem setDelegate:self];
    [self.statusItem setMenu:self.statusMenu];
    [self.statusItem setImage:[NSImage imageNamed:@"MacSoundBarIcon.png"]];
    [self.statusItem setAlternateImage:[NSImage imageNamed:@"MacSoundBarIcon_invert.png"]];
    [self.statusItem setHighlightMode:YES];
    
    [[self.statusItem view] addSubview:self.star];
    
    NSArray *draggedTypeArray = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
    [self.statusItem registerForDraggedTypes:draggedTypeArray];    
    [self refreshMenu];
    
    self.star.frame = NSMakeRect(6.0, 2.0, 25.0, 25.0);
    self.star.wantsLayer = YES;
//    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
//    [filter setDefaults];
//    [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputRadius"];
//    [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];    
//    [self.star.layer setFilters:[NSArray arrayWithObject:filter]];
    
    self.star.layer.opacity = 0.0;
    self.star.hidden = YES;
    
    self.flashStarAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    self.flashStarAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.0], nil];
    self.flashStarAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:1.0], nil];
    self.flashStarAnimation.duration = 1.5;
    self.flashStarAnimation.delegate = self;
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
            selector:@selector(flashStar) name:@"play" object:@"MacSoundBarHelper"];

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(playByNotification:) name:@"play" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(listAll) name:@"list" object:nil];
}

- (NSArray*)listAll {
    return [self.soundManager findAll];
}

- (void)flashStar {
    [self.star setHidden:NO];
    [[self.star layer] addAnimation:self.flashStarAnimation forKey:@"flashStar"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        self.star.layer.opacity = 0.0;
        [self.star setHidden:YES];   
    }
}

- (BOOL)fileAtPath:(NSString *)path conformsToUTI:(NSString *)identifier {
    CFStringRef fileExtension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    return UTTypeConformsTo(fileUTI, (__bridge CFStringRef)identifier);
}

- (BOOL)isSound:(NSString *)path {
    return [self fileAtPath:path conformsToUTI:@"public.audio"];
}

- (BOOL)isZip:(NSString *)path {
    return [self fileAtPath:path conformsToUTI:@"com.pkware.zip-archive"];
}

- (BOOL)isFolder:(NSString *)path {
    BOOL isDir;
    return ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir);
}

- (BOOL)isAddableResourceAtPath:(NSString *)path {
    return ([self isSound:path] || [self isZip:path] || [self isFolder:path]);
}

- (NSDragOperation)statusItemView:(StatusItemDropView *)view draggingEntered:(id <NSDraggingInfo>)sender {
	NSLog(@"Drag entered!");
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *file in files) {
            if ([self isAddableResourceAtPath:file]) {
                return NSDragOperationCopy;
            }
        }
    }    
	return NSDragOperationNone;
}

- (void)statusItemView:(StatusItemDropView *)view draggingExited:(id <NSDraggingInfo>)sender {
	NSLog(@"Dragging exit");
}

- (BOOL)statusItemView:(StatusItemDropView *)view prepareForDragOperation:(id <NSDraggingInfo>)sender {
	NSLog(@"Prepare for drag");
	return YES;
}

- (BOOL)statusItemView:(StatusItemDropView *)view performDragOperation:(id <NSDraggingInfo>)sender {
	NSLog(@"Perform drag");
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *file in files) {
            if ([self isAddableResourceAtPath:file]) {
                [self addFile:[NSURL fileURLWithPath:file]];
            }
        }
        [self saveAction:nil];
        [self flashStar];
        [self refreshMenu];
    }
	return YES;
}

- (void)deleteItem:(NSString *)name {
    NSLog(@"deleteItem: \"%@\"", name);
    [self.soundManager deleteByName:name];
    [self saveAction:nil];
    [self refreshMenu];
}

-(void)moveItem:(NSString *)name toIndex:(NSInteger)index {
    NSLog(@"moveItem: \"%@\" toIndex:%ld", name, index-1);
    [soundManager moveSound:name toIndex:index-1];
    [self saveAction:nil];
    [self refreshMenu];
}

- (void)refreshMenu {
    //NSLog(@"Refresh Menu");
    [statusMenu removeAllItems];
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"About MacSoundBar" action:@selector(openAbout:) keyEquivalent:@""];
    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
    [item setEnabled:YES];
    [item setTarget:self];
    [self.statusMenu addItem:item];
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    NSArray *sounds = [self.soundManager findAll];
    int key = 0;
    for (Sound *sound in sounds) {
        key++;
        NSString *keyEquivalent = @"";
        NSInteger modifierMask = 0;
        if (key <= MAX_KEYS) {
//            unichar key = NSF1FunctionKey + key;
//            keyEquivalent = [NSString stringWithCharacters:&key length:1];
            keyEquivalent = [NSString stringWithFormat:@"F%d",key];
            modifierMask = MODIFIER_MASK;
        }
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:sound.name action:@selector(play:) keyEquivalent:keyEquivalent];
        [item setKeyEquivalentModifierMask:modifierMask];
        [item setEnabled:YES];
        [item setView:[[SoundItemView alloc] initWithSizeForLabel:item.title]];
        [item setTarget:self];
        [self.statusMenu addItem:item];
    }
    if ([sounds count] == 0) {
        NSMenuItem *infoItem = [[NSMenuItem alloc] initWithTitle:@"No sound added yet!" action:nil keyEquivalent:@""];
        [infoItem setEnabled:NO];           
        [self.statusMenu addItem:infoItem];
    }
    [self.statusMenu addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem alloc] initWithTitle:@"Add Sound..." action:@selector(openFile) keyEquivalent:@""];
    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
    [item setEnabled:YES];
    [item setTarget:self];
    [self.statusMenu addItem:item];

//    item = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(openPreferences:) keyEquivalent:@""];
//    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
//    [item setEnabled:YES];
//    [item setTarget:self];
//    [self.statusMenu addItem:item];
    
    [self.statusMenu addItem:[NSMenuItem separatorItem]]; 
    
    item = [[NSMenuItem alloc] initWithTitle:@"Quit MacSoundBar" action:@selector(terminate) keyEquivalent:@""];
    [item setView:[[SimpleItemView alloc] initWithSizeForLabel:item.title]];
    [item setEnabled:YES];
    [item setTarget:self];
    [self.statusMenu addItem:item];    
}

-(void)terminate {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)openPreferences:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self.preferencesWindow makeKeyAndOrderFront:self];
}

- (void)openAbout:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [self.aboutWindow makeKeyAndOrderFront:self];
}

- (void)openFile {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setAllowsMultipleSelection:YES];
    [openDlg setDelegate:self];
    if ([openDlg runModal] == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [openDlg URLs]) {
            [self addFile:url];
        }
        [self.mom save:NULL];
        [self flashStar];
        [self refreshMenu];
    }
}

-(BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    return ([self isAddableResourceAtPath:url.path]);
}

- (void)addFile:(NSURL *)url {
    if ([self isFolder:url.path]) {
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:url.path error:NULL];
        for (NSString *file in files) {
            [self addFile:[url URLByAppendingPathComponent:file]];
        }
    } else if ([self isZip:url.path]) {
        NSMutableString *dir = [[NSMutableString alloc]initWithString: [NSTemporaryDirectory() stringByAppendingPathComponent:@"MacSoundBar_"]];
        for (int i=0; i<20; i++) {
            [dir appendFormat: @"%d", (arc4random() % 10)];
        }
        NSLog(@"Unzipping to temp dir: %@", dir);
        [SSZipArchive unzipFileAtPath:url.path toDestination:dir];
        NSString *name = [[url lastPathComponent] stringByDeletingPathExtension];
        NSString *path = [dir stringByAppendingPathComponent:name];
        [self addFile:[NSURL fileURLWithPath:path]];
        [[NSFileManager defaultManager] removeItemAtPath:dir error:NULL];
        
    } else if ([self isSound:url.path]) {
        NSString *name = [[url lastPathComponent] stringByDeletingPathExtension];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self.soundManager addSound:name withData:data];
    }
}

- (void)play:(id)sender {
    [self playByName:[sender title]];
}

- (void)playByName:(NSString *)name {
    NSLog(@"playByName \"%@\"", name);
    Sound *sound = [self.soundManager findByName:name];
    [[[NSSound alloc] initWithData:sound.data] play];
}

-(void)playByNotification:(NSNotification *)notification {
    NSString *name = [notification.userInfo objectForKey:@"sound"]; 
    Sound *sound = [self.soundManager findByContainedName:name];
    [[[NSSound alloc] initWithData:sound.data] play];
}


/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self.mom managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction) saveAction:(id)sender {
    NSError *error = nil;
    if (![self.mom save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    NSError *error = nil;    
    if (![self.mom save:&error]) {
        
        // Customize this code block to include application-specific recovery steps.              
        if ([sender presentError:error]) {
            return NSTerminateCancel;
        }
        
        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }
    return NSTerminateNow;   
}


@end
