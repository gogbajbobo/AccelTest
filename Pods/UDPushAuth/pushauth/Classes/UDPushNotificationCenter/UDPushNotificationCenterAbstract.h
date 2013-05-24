//
//  UDPushNotificationCenter.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushNotificationProcessable.h"

@interface UDPushNotificationCenterAbstract : NSObject
- (void) addObserver:(id)observer;
- (void) removeObserver:(id)observer;
- (void) processPushNotification:(NSDictionary *) userInfo;
- (void) addPushNotificationProcessor:(id <UDPushNotificationProcessable>) notificationProcessor;
- (void) removePushNotificationProcessor:(id <UDPushNotificationProcessable>) notificationProcessor;
+ (id) pushNotificationCenter;
@end
