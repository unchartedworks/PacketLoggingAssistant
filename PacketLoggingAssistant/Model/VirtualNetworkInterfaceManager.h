//
//  VirtualNetworkInterfaceManager.h
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceMonitor.h"

@protocol VirtualNetworkInterfaceManagerDelegate;

@interface VirtualNetworkInterfaceManager : NSObject

@property (unsafe_unretained) id <VirtualNetworkInterfaceManagerDelegate> delegate;

+ (VirtualNetworkInterfaceManager*)sharedInstance;

- (void)addNetworkInfaceWithUDID:(NSString *)udid error:(NSError **)error;
- (void)removeNetworkInfaceWithUDID:(NSString *)udid error:(NSError **)error;
@end

@protocol VirtualNetworkInterfaceManagerDelegate <NSObject>
@optional
- (void)virtualNetworkInterfaceManager:(VirtualNetworkInterfaceManager *)manager didUpdateVirtualNetworkInterface:(NSDictionary *)userInfo;

@end