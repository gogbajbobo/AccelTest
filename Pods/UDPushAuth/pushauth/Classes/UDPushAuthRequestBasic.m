//
//  UDPushAuthRequestBasic.m
//  pushauth
//
//  Created by kovtash on 13.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthRequestBasic.h"
#import "GDataXMLNode.h"

@implementation UDPushAuthRequestBasic
@synthesize uPushAuthServiceURI = _uPushAuthServiceURI;
@synthesize appID = _appID;


- (NSString *)constantGetParameters{
    if (_constantGetParameters ==nil) {
        _constantGetParameters = @"";
    }
    
    return _constantGetParameters;
}
- (NSString *) deviceType{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"ipad";
    }else{
        return @"iphone";
    }
}

- (void) registerDeviceWithPushToken:(NSString *)pushToken andCompleteonHandler:(void (^)(NSString *, BOOL))completeonHandler {
    NSURLRequest * request = [self requestWithResource:@"register" Parameters:[NSString stringWithFormat:@"push_token=%@&device_type=%@",pushToken,self.deviceType]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *deviceIDNode = [[responseXML nodesForXPath:@"/response/device_id" error:nil] lastObject];
        
        if (deviceIDNode == nil) {
            NSLog(@"deviceID Node error");
            return;
        }
        
        completeonHandler(deviceIDNode.stringValue,NO);
    }];
    
}
- (void) activateDevice:(NSString *) deviceID WithActivationCode:(NSString *) activationCode CompleteonHandler:(void ( ^ ) (BOOL activationStatus)) completeonHandler{
    NSURLRequest * request = [self requestWithResource:@"activate" Parameters:[NSString stringWithFormat:@"device_id=%@&activation_code=%@",deviceID,activationCode]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"activate error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *authCodeNode = [[responseXML nodesForXPath:@"/response/activate" error:nil] lastObject];
        
        if (authCodeNode == nil) {
            NSLog(@"activateCode Node error");
            completeonHandler(NO);
            return;
        }
        
        if ([authCodeNode.stringValue isEqualToString:@"yes"]) {
            completeonHandler(YES);
        }
        else{
            completeonHandler(NO);
        }
        
    }];
    
}

- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode, NSString *codeIdentifier)) completeonHandler{
    NSURLRequest * request = [self requestWithResource:@"auth" Parameters:[NSString stringWithFormat:@"client_id=test&redirect_uri=upush://%@",deviceID]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){
        if (error != nil) {
            NSLog(@"auth error %@",error);
            return;
        }
        
        GDataXMLDocument * responseXML = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        if (responseXML == nil) {
            NSLog(@"xml document error");
            return;
        }
        
        GDataXMLNode *authCodeNode = [[responseXML nodesForXPath:@"/response/code" error:nil] lastObject];
        GDataXMLNode *authCodeIDNode = [[responseXML nodesForXPath:@"/response/id" error:nil] lastObject];
        
        if (authCodeNode == nil) {
            NSLog(@"authCode Node error");
            return;
        }
        
        completeonHandler(authCodeNode.stringValue,authCodeIDNode.stringValue);
    }];
}

- (NSURLRequest *) requestWithResource:(NSString *) resource Parameters:(NSString *) parameters{
    NSURL *url = [self.uPushAuthServiceURI URLByAppendingPathComponent:resource];
    parameters = [parameters stringByAppendingFormat:@"&%@",self.constantGetParameters];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *requestPOSTData = [NSData dataWithBytes: [parameters UTF8String] length: [parameters length]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestPOSTData];
    
    return request;
}

@end
