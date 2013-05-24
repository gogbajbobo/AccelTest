//
//  UDPushNotificationCenter.m
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushNotificationCenterAbstract.h"

@interface UDPushNotificationCenterAbstract()
@property (strong,nonatomic) NSArray *notificationObservers;
@property (strong,nonatomic) NSArray *notificationProcessors;
@end


@implementation UDPushNotificationCenterAbstract
#pragma mark - Properties
- (NSArray *) notificationObservers{
    if (_notificationObservers == nil) {
        _notificationObservers = [NSArray array];
    }
    
    return _notificationObservers;
}

- (NSArray *) notificationProcessors {
    if (_notificationProcessors == nil) {
        _notificationProcessors = [NSArray array];
    }
    
    return _notificationProcessors;
}
#pragma mark - Methods

- (void) addObserver:(id)observer{
    NSMutableArray *mutableNotificationObservers = [self.notificationObservers mutableCopy];
    
    [mutableNotificationObservers addObject:observer];
    
    self.notificationObservers = mutableNotificationObservers;
    
    [self refreshProcessorsNotificationObserverList];
}

- (void) removeObserver:(id)observer{
    NSMutableArray *mutableNotificationObservers = [self.notificationObservers mutableCopy];
    
    [mutableNotificationObservers removeObject:observer];
    
    self.notificationObservers = mutableNotificationObservers;
    
    [self refreshProcessorsNotificationObserverList];
}

- (void) refreshProcessorsNotificationObserverList{
    for (id <UDPushNotificationProcessable> notificationProcessor in self.notificationProcessors) {
        notificationProcessor.notificationObservers = self.notificationObservers;
    }
}

- (void) addPushNotificationProcessor:(id <UDPushNotificationProcessable>)notificationProcessor{
    if ([notificationProcessor conformsToProtocol:@protocol(UDPushNotificationProcessable)]) {
        NSMutableArray *mutableNotificationProcessors = [self.notificationProcessors mutableCopy];
        
        [mutableNotificationProcessors addObject:notificationProcessor];
        notificationProcessor.notificationObservers = self.notificationObservers;
        
        self.notificationProcessors = mutableNotificationProcessors;
    }
}

- (void) removePushNotificationProcessor:(id <UDPushNotificationProcessable>) notificationProcessor{
    NSMutableArray *mutableNotificationProcessors = [self.notificationProcessors mutableCopy];
    
    [mutableNotificationProcessors removeObject:notificationProcessor];
    
    self.notificationProcessors = mutableNotificationProcessors;
}

- (void) processPushNotification:(NSDictionary *)userInfo{
    for (id <UDPushNotificationProcessable> processor in self.notificationProcessors) {
        [processor processPushNotification:userInfo];
    }
}

+ (id) pushNotificationCenter{
    return [[[self class] alloc] init];;
}

@end
