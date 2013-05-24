//
//  UDPushAuthStorageProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushAuthStorageDelegate <NSObject>
@property (readwrite) NSString *deviceID;
@property (readwrite) NSData *pushToken;
@end
