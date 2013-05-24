//
//  UDAuthTokenRetriever.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetriever.h"
#import "UDPushAuthCodeRetriever.h"
#import "GDataXMLNode.h"

#define DEFAULT_ACCESS_TOKEN_LIFETIME 3600
#define DEFAULT_REFRESH_TOKEN_LIFETIME 3600*24*30

@implementation UDAuthTokenRetriever
- (void) performTokenRequestWithAuthCode:(NSString *)authCode andRedirectURI:(NSString *)redirectURI{
    NSString *requestParameters = [NSString stringWithFormat:@"e_service=upushauth&client_id=test&e_code=%@&redirect_uri=%@",authCode,redirectURI];
    NSURLRequest * request = [self requestWithResource:@"auth" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) requestTokenWithAuthCode:(NSString *) code ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *requestParameters = [NSString stringWithFormat:@"client_id=%@&code=%@&client_secret=%@",clientID,code,clientSecret];
    NSURLRequest * request = [self requestWithResource:@"token" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) requestTokenWithRefreshToken:(NSString *) refreshToken ClientID:(NSString *) clientID ClientSecret:(NSString *) clientSecret{
    NSString *requestParameters = [NSString stringWithFormat:@"client_id=%@&refresh_token=%@&client_secret=%@",clientID,refreshToken,clientSecret];
    NSURLRequest * request = [self requestWithResource:@"token" Parameters:requestParameters];
    
    __weak __typeof(&*self) weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        [weakSelf processTokenResponse:response Data:data Error:error];
    }];
}

- (void) processTokenResponse:(NSURLResponse *) response Data:(NSData *) data Error:(NSError *) error{
    if (error != nil) {
        NSLog(@"auth error %@",error);
        return;
    }
    
    GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    if (responseXML == nil) {
        NSLog(@"xml document error");
        return;
    }
    
    NSDictionary *xmlns = [NSDictionary dictionaryWithObject:@"http://unact.net/xml/oauth" forKey:@"oauth"];
    
    GDataXMLElement *accessTokenValue = nil;
    
    
    if ([responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil].count > 0) {
        accessTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:access-token" namespaces:xmlns error:nil] objectAtIndex:0];
    }
    
    if (accessTokenValue != nil) {
        NSTimeInterval lifetime = [self lifetimeFrom:accessTokenValue WithDefaultValue:DEFAULT_ACCESS_TOKEN_LIFETIME];
        UDAuthToken * accessToken = [UDAuthToken accessTokenWithWalue:accessTokenValue.stringValue Lifetime:lifetime];
        [self tokenReceived:accessToken];
    }
    
    GDataXMLNode *refreshTokenValue = nil;
    
    if ([responseXML nodesForXPath:@"oauth:response/oauth:refresh-token" namespaces:xmlns error:nil].count > 0) {
        refreshTokenValue = [[responseXML nodesForXPath:@"oauth:response/oauth:refresh-token" namespaces:xmlns error:nil] objectAtIndex:0];
    }
    
    if (refreshTokenValue != nil){
        NSTimeInterval lifetime = [self lifetimeFrom:accessTokenValue WithDefaultValue:DEFAULT_REFRESH_TOKEN_LIFETIME];
        UDAuthToken * refreshToken = [UDAuthToken refreshTokenWithWalue:refreshTokenValue.stringValue Lifetime:lifetime];
        [self tokenReceived:refreshToken];
    }
}

- (NSTimeInterval) lifetimeFrom:(GDataXMLElement *) element WithDefaultValue:(NSTimeInterval) defaultValue{
    NSTimeInterval lifetime = defaultValue;
    NSString *lifetimeString = [[element attributeForName:@"expire-after"] stringValue];
    
    if (lifetimeString) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        lifetime = [[formatter numberFromString:lifetimeString] doubleValue];
    }
    
    return lifetime;
}

+ (id) tokenRetriever{
    UDAuthTokenRetriever *tokenRetriever = [[self alloc] init];
    tokenRetriever.codeDelegate = [UDPushAuthCodeRetriever codeRetriever];
    return tokenRetriever;
}

- (NSURLRequest *) requestWithResource:(NSString *) resource Parameters:(NSString *) parameters{
    NSURL *url = [self.authServiceURI URLByAppendingPathComponent:resource];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *requestPOSTData = [NSData dataWithBytes: [parameters UTF8String] length: [parameters length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestPOSTData];
    
    return request;
}
@end
