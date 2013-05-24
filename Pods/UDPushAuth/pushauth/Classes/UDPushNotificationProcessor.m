//
//  UDUDUPushNotificationProcessorWrk.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationProcessor.h"
#import "UDPushAuthProcessableProtocol.h"
#import "UDPushAuthActivationCode.h"
#import "UDPushAuthClientSecret.h"

@implementation UDPushNotificationProcessor

- (void) performActionForKey:(NSString *) key andObject:(id) object{
    if ([key isEqualToString:@"activation_code"]) {
        UDPushAuthActivationCode *activationCode = [[UDPushAuthActivationCode alloc] init];
        activationCode.objectValue = object;
        [self notifyObserversWithObject:activationCode];
    }
    else if ([key isEqualToString:@"client_secret"]){
        
        if ([object objectForKey:@"value"] != nil && [object objectForKey:@"id"] != nil) {
            UDPushAuthClientSecret *clientSecret = [[UDPushAuthClientSecret alloc] init];
            clientSecret.objectValue = [object objectForKey:@"value"];
            clientSecret.secretID = [object objectForKey:@"id"];
            [self notifyObserversWithObject:clientSecret];
        }
    }
}

- (void) notifyObserversWithObject:(id) pushObject{
    for (id observer in self.notificationObservers) {
        if ([observer conformsToProtocol:@protocol(UDPushAuthProcessable)]) {
            [observer pushMessageReceived:pushObject];
        }
    }
}

@end
