//
//  UDAuthTokenProcessable.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDAuthToken.h"
#import "UDAuthCodeRetrieverableProtocol.h"

@protocol UDAuthTokenProcessable <NSObject>
@property (nonatomic,strong) id <UDAuthCodeRetrieverable> codeDelegate;
@property (nonatomic,strong) NSURL *authServiceURI;
- (void) tokenReceived:(UDAuthToken *) token;
- (void) performTokenRequestWithAuthCode:(NSString *) authCode andRedirectURI:(NSString *) redirectURI;
@end
