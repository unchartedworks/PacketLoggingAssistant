
//
//  VirtualNetworkInterfaceManagerSpec.m
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import "Kiwi.h"
#import "VirtualNetworkInterfaceManager.h"

SPEC_BEGIN(VirtualNetworkInterfaceManagerSpec)

describe(@"VirtualNetworkInterfaceManager", ^{
    VirtualNetworkInterfaceManager *manager = [VirtualNetworkInterfaceManager sharedInstance];
    it(@"adds/removes virtual network interface", ^{
        NSError *error = nil;
        NSString *udid = @"3731528b5cfb06e4c1c47fa9d9de1b8d344cd3e3";
        [manager addNetworkInfaceWithUDID:udid error:&error];
        [[error should] beNil];
        [manager removeNetworkInfaceWithUDID:udid error:&error];
        [[error should] beNil];
    });
});

SPEC_END
