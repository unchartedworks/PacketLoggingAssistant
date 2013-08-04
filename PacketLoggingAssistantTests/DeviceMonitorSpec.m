//
//  PacketLoggingAssistantTests.m
//  PacketLoggingAssistantTests
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import "Kiwi.h"
#import "DeviceMonitor.h"

SPEC_BEGIN(DeviceMonitorSpec)

describe(@"DeviceMonitor", ^{
    DeviceMonitor *devcieMonitor = [DeviceMonitor sharedInstance];
    it(@"monitors device status", ^{
        KWMock *mock = [KWMock mockForProtocol:@protocol(DeviceMonitorDelegate)];
        devcieMonitor.delegate = mock;
        [devcieMonitor startMonitoringDevice];
        [[mock shouldEventually] receive:@selector(deviceMonitor:didUpdateDevice:) withCountAtLeast:1];
        sleep(3);
        
        [devcieMonitor stopMonitoringDevice];
    });
});

SPEC_END
