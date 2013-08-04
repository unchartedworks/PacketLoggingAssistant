//
//  WindowController.h
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DeviceMonitor.h"

@interface WindowController : NSWindowController<DeviceMonitorDelegate, NSAlertDelegate>
@property (weak) IBOutlet NSArrayController *deviceArrayController;
@property (weak) IBOutlet NSTableView *tableView;

@end
