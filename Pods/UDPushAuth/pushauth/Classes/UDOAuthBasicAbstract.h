//
//  UDOAuthBasic.h
//  pushauth
//
//  Created by kovtash on 21.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDTokenRetrieverDelegate.h"
#import "UDAuthTokenRetrievable.h"
#import "UDAuthCodeRetrieverDelegate.h"

@interface UDOAuthBasicAbstract : NSObject <UDTokenRetrieverDelegate,UDAuthCodeRetrieverDelegate>
@property (strong,nonatomic) id <UDAuthTokenRetrievable> tokenRetriever;
@property (readonly,nonatomic) NSString *reachabilityServer;
@property (strong,nonatomic) NSString *clientID;
@property (readonly,nonatomic) NSString *tokenValue;
@property (readonly,nonatomic) UDAuthToken *authToken;
- (void) forceTokenRequest;
- (void) checkToken;
- (void) reachabilityChanged:(NSNotification *)notification;
- (void) setClientSecret:(NSString *) clientSecret;
+ (id)sharedOAuth;
+ (id) tokenRetrieverMaker;
@end
