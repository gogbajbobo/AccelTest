//
//  UDPushNotificationProcessable.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushNotificationProcessable <NSObject>
@property (nonatomic,weak) NSArray *notificationObservers;
- (void) processPushNotification:(NSDictionary *) userInfo;
@end
