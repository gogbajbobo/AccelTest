//
//  UDAuthTokenRetrieverAbstract.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetrieverAbstract.h"

@implementation UDAuthTokenRetrieverAbstract
@synthesize codeDelegate = _codeDelegate;
@synthesize delegate = _delegate;
@synthesize authServiceURI = _authServiceURI;

- (void) setCodeDelegate:(id<UDAuthCodeRetrieverable>)codeDelegate{
    if (_codeDelegate != codeDelegate) {
        _codeDelegate = codeDelegate;
        
        if (self.codeDelegate != nil) {
            self.codeDelegate.codeDelegate = self;
        }
    }
}

- (void) requestToken{
    [self.codeDelegate requestAuthCode];
}

- (void) requestTokenWithAuthCode:(NSString *) code ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    
}

- (void) requestTokenWithRefreshToken:(NSString *) code ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    
}

- (void) authCodeReceived:(NSString *)authCode forRedirectURI:(NSString *)redirectUri{
    [self performTokenRequestWithAuthCode:authCode andRedirectURI:redirectUri];
}

- (void) tokenReceived:(UDAuthToken *)token{
    [self.delegate tokenReceived:token];
}

- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    NSLog(@"Auth Code: %@ %@", authCode, redirectURI);
}
@end
