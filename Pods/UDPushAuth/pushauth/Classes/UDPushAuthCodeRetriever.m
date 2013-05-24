//
//  UDPushAuthCodeRetriever.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthCodeRetriever.h"
#import "UDPushAuthRequestBasic.h"
#import "UDPushAuthStorageBasic.h"
#import "UDPushNotificationCenter.h"

@implementation UDPushAuthCodeRetriever
- (NSString *) redirectURI{
    return [NSString stringWithFormat:@"upush://%@",self.deviceId];
}

+ (id) codeRetriever{
    
    UDPushAuthCodeRetriever *codeRetriever = [[self alloc] init];
    codeRetriever.requestDelegate = [[UDPushAuthRequestBasic alloc] init];
    codeRetriever.storageDelegate = [[UDPushAuthStorageBasic alloc] init];
    
    [[UDPushNotificationCenter sharedPushNotificationCenter] addObserver:codeRetriever];
    
    return codeRetriever;
}

- (void)dealloc{
    [[UDPushNotificationCenter sharedPushNotificationCenter] removeObserver:self];
}
@end
