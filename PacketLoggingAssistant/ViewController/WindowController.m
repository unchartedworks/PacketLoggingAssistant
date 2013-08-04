//
//  WindowController.m
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import "WindowController.h"
#import "VirtualNetworkInterfaceManager.h"
#import "AppDelegate.h"

@interface WindowController () {
}
@property (atomic) NSMutableArray *devices;

@end

@implementation WindowController
#pragma mark - Init
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    DeviceMonitor *devcieMonitor    = [DeviceMonitor sharedInstance];
    devcieMonitor.delegate          = self;
    [devcieMonitor startMonitoringDevice];
    _devices                        = [[NSMutableArray alloc] init];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[_deviceArrayController arrangedObjects] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView       = [tableView makeViewWithIdentifier:@"DeviceCell" owner:self];
    cellView.textField.stringValue  = [[_deviceArrayController arrangedObjects] objectAtIndex:row];
    return cellView;
}

#pragma mark - DeviceMonitorDelegate
- (void)deviceMonitor:(DeviceMonitor *)deviceMonitor didUpdateDevice:(NSDictionary *)userInfo {
    NSString *udid          = userInfo[@"udid"];
    NSNumber *msg           = userInfo[@"msg"];
    __block NSError *error  = nil;

    AppDelegate *appDelegate    = [NSApplication sharedApplication].delegate;
    NSMenu *menu                = appDelegate.statusMenu;
    
    switch (msg.integerValue) {
        case MSG_CONNECTED: {
            if (![self.devices containsObject:udid]) {
                [self.devices addObject:udid];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMenuItem *item    = [[NSMenuItem alloc] initWithTitle:udid action:@selector(openWireShark:) keyEquivalent:@""];
                    [item setTarget:self];
                    [item setEnabled:YES];
                    item.tag            = 'udid';
                    NSInteger index     = [menu numberOfItems] - 2;
                    [menu insertItem:item atIndex:index];
                });
            }
   
            [[VirtualNetworkInterfaceManager sharedInstance] addNetworkInfaceWithUDID:udid error:&error];
        }
            break;
        case MSG_DISCONNECTED: {
            [self.devices removeObject:udid];
            for (NSMenuItem *item in [menu itemArray]) {
                if ([item.title isEqualToString:udid]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [menu removeItem:item];
                    });
                }
            }
            [[VirtualNetworkInterfaceManager sharedInstance] removeNetworkInfaceWithUDID:udid error:&error];
        }
            break;
        case MSG_UNKNOWN:
            break;
    }
}

- (void)deviceMonitor:(DeviceMonitor *)deviceMonitor didFailWithError:(NSError *)error {
    
}

#pragma mark - IBActions
- (IBAction)openWireShark:(id)sender {
    BOOL result = [[NSWorkspace sharedWorkspace] launchApplication:@"/Applications/Wireshark.app"];
    if (result == NO) {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert setMessageText:@"You haven't installed Wireshark!"];
        [alert setInformativeText:@"Please click OK to download Wireshark."];
        
        alert.delegate = self;
        
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [[NSWorkspace sharedWorkspace] openURL:
     [NSURL URLWithString:@"http://www.wireshark.org/download.html"]];
}

- (IBAction)quit:(id)sender {
    AppDelegate *appDelegate = [NSApplication sharedApplication].delegate;
    NSMenu *menu = appDelegate.statusMenu;
    for (NSMenuItem *item in [menu itemArray]) {
        if (item.tag == 'udid') {
            NSString *udid = item.title;
            NSError *error = nil;
            [[VirtualNetworkInterfaceManager sharedInstance] removeNetworkInfaceWithUDID:udid error:&error];
        }
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [NSApp terminate:self];
    });
}

@end
