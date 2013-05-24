//
//  UDPushNotificationCenter.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationCenter.h"
#import "UDPushNotificationCenterAbstract.h"
#import "UDPushNotificationProcessorBasic.h"
#import "UDPushNotificationProcessor.h"

@implementation UDPushNotificationCenter
+ (id)sharedPushNotificationCenter
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
#if DEBUG
        [_sharedObject addPushNotificationProcessor:[UDPushNotificationProcessorBasic notificationProcessor]];
#endif
        
        [_sharedObject addPushNotificationProcessor:[UDPushNotificationProcessor notificationProcessor]];
    });
    return _sharedObject;
}

@end
