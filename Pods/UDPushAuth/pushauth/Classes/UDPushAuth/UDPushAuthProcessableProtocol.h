//
//  UDDeviceIDHandlerProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushAuthRequestDelegate.h"
#import "UDPushAuthStorageDelegate.h"

@protocol UDPushAuthProcessable <NSObject>
@property (nonatomic,readonly) NSString *deviceId;
@property (nonatomic,strong) NSString *redirectURI;
@property (strong,nonatomic) id <UDPushAuthRequestDelegate> requestDelegate;
@property (strong,nonatomic) id <UDPushAuthStorageDelegate> storageDelegate;
- (void) registerDeviceWithPushToken:(NSData *) pushToken;
- (void) pushMessageReceived:(id) pushObject;
- (void) activationCodeReceived:(NSString *) activationCode;
- (void) clientSecretReceived:(NSString *) clientSecret withID:(NSString *) secretID;
@end
