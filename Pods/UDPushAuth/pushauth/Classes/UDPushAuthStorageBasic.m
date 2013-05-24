//
//  UDPushAuthStorageBasic.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthStorageBasic.h"
 
#define DEVICE_ID_KEY @"UDPushAuthDeviceIDBasic"
#define PUSH_TOKEN_KEY @"UDPushAuthTokenBasic"

@interface UDPushAuthStorageBasic()
@end

@implementation UDPushAuthStorageBasic
@synthesize deviceID = _deviceID;
@synthesize pushToken = _pushToken;

- (NSString *) deviceID{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DEVICE_ID_KEY];
}

- (void) setDeviceID:(NSString *)deviceID{
    if (deviceID != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:DEVICE_ID_KEY];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:PUSH_TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSData *) pushToken{
    return [[NSUserDefaults standardUserDefaults] dataForKey:PUSH_TOKEN_KEY];
}

- (void) setPushToken:(NSData *)pushToken{    
    if (pushToken != nil && ![pushToken isEqualToData:self.pushToken]) {
        [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:PUSH_TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
