//
//  VirtualNetworkInterfaceManager.m
//  PacketLoggingAssistant
//
//  Created by Liang on 13/07/2013.
//  Copyright (c) 2013 Uncharted Works. All rights reserved.
//

#import "VirtualNetworkInterfaceManager.h"

@interface VirtualNetworkInterfaceManager() {
    dispatch_queue_t _serialQueue;
}

@end

@implementation VirtualNetworkInterfaceManager
+ (VirtualNetworkInterfaceManager*)sharedInstance {
    static VirtualNetworkInterfaceManager* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance                 = [[VirtualNetworkInterfaceManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        _serialQueue    = dispatch_queue_create("com.uw.pla.virtualnetworkinterfacemananager", NULL);
    }
    return self;
}

- (void)addNetworkInfaceWithUDID:(NSString *)udid error:(NSError **)error {
    dispatch_async(_serialQueue, ^{
        [self _configureNetworkInterfaceWithUDID:udid error:error start:NO];
        sleep(1.0);
        [self _configureNetworkInterfaceWithUDID:udid error:error start:YES];
        sleep(1.0);
        if (*error) {
            [self _configureNetworkInterfaceWithUDID:udid error:error start:NO];
            sleep(1.0);
            [self _configureNetworkInterfaceWithUDID:udid error:error start:YES];
        }
        
    });
}

- (void)removeNetworkInfaceWithUDID:(NSString *)udid error:(NSError **)error {
    dispatch_async(_serialQueue, ^{
        [self _configureNetworkInterfaceWithUDID:udid error:error start:NO];
        sleep(0.5);
    });
}

- (void)configureNetworkInterfaceWithUDID:(NSString *)udid error:(NSError **)error start:(BOOL)start {
    dispatch_async(_serialQueue, ^{
        [self _configureNetworkInterfaceWithUDID:udid error:error start:start];
    });
}

- (void)_configureNetworkInterfaceWithUDID:(NSString *)udid error:(NSError **)error start:(BOOL)start {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/rvictl"];
    
    NSString *option    = start ? @"-s" : @"-x";
    NSArray *arguments  = @[option, udid];
    
    [task setArguments: arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *result = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSRange range = [result rangeOfString:@"[SUCCEEDED]"];
    if (range.location != NSNotFound) {
        *error = nil;
    }
    
    range = [result rangeOfString:@"[FAILED]"];
    if (range.location != NSNotFound) {
        NSDictionary *userInfo = @{@"message":result};
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-1 userInfo:userInfo];
        NSLog (@"error = %@", *error);
    }
}

@end
