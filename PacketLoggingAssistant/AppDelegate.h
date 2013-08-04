//
//  AppDelegate.h
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (unsafe_unretained) IBOutlet NSWindow *aboutWindow;

- (IBAction)saveAction:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)gotoWebsite:(id)sender;
@end
