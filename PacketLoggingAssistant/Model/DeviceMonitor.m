//
//  DeviceMonitor.m
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import "DeviceMonitor.h"
#import "MobileDevice.h"

static struct am_device_notification *notify;

void device_callback(struct am_device_notification_callback_info *info, void *arg);

@interface DeviceMonitor() {
    dispatch_queue_t _serialQueue;
}

@end

@implementation DeviceMonitor
+ (DeviceMonitor*)sharedInstance {
    static DeviceMonitor* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance                 = [[DeviceMonitor alloc] init];
    });
    return _sharedInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        _serialQueue    = dispatch_queue_create("com.uw.devicemointor", NULL);
    }
    return self;
}

- (void)startMonitoringDevice {
    dispatch_async(_serialQueue, ^{
        [self _startMonitoringDevice];
    });
}

- (void)stopMonitoringDevice {
    
}

- (void)_startMonitoringDevice {
    AMDSetLogLevel(5); // otherwise syslog gets flooded
    
    //static struct am_device_notification *notify;
    AMDeviceNotificationSubscribe(&device_callback, 0, 0, NULL, &notify);
    CFRunLoopRun();
}

@end

void device_callback(struct am_device_notification_callback_info *info, void *arg) {
    switch (info->msg) {
        case ADNCI_MSG_CONNECTED:
        case ADNCI_MSG_DISCONNECTED:{
            CFStringRef found_device_id = AMDeviceCopyDeviceIdentifier(info->dev);
            const char* uuidStr         = CFStringGetCStringPtr(found_device_id, CFStringGetSystemEncoding());
            NSString *uuid              = [NSString stringWithUTF8String:uuidStr];
            NSLog(@"%@ : %d", uuid, info->msg);
            DeviceMonitor *deviceMonitor = [DeviceMonitor sharedInstance];
            if (deviceMonitor.delegate && [deviceMonitor.delegate respondsToSelector:@selector(deviceMonitor:didUpdateDevice:)]) {
                NSDictionary *userInfo = @{@"udid":uuid, @"msg":@(info->msg)};
                [deviceMonitor.delegate deviceMonitor:deviceMonitor didUpdateDevice:userInfo];
            }
        }
            break;
        default:
            break;
    }
}
