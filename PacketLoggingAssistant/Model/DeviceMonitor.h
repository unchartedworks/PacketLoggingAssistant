//
//  DeviceMonitor.h
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MSG_CONNECTED     1
#define MSG_DISCONNECTED  2
#define MSG_UNKNOWN       3

@interface DeviceMonitor : NSObject

@property (unsafe_unretained) id delegate;

+ (DeviceMonitor*)sharedInstance;

- (void)startMonitoringDevice;
- (void)stopMonitoringDevice;
@end

@protocol DeviceMonitorDelegate <NSObject>
@optional
- (void)deviceMonitor:(DeviceMonitor *)deviceMonitor didUpdateDevice:(NSDictionary *)userInfo;
- (void)deviceMonitor:(DeviceMonitor *)deviceMonitor didFailWithError:(NSError *)error;
@end
