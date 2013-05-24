//
//  UDDeviceIDHandler.m
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDPushAuthCodeRetrieverAbstract.h"
#import "UDPushAuthActivationCode.h"
#import "UDPushAuthClientSecret.h"

@interface UDPushAuthCodeRetrieverAbstract()
@property (strong, nonatomic) NSString *clientCode;
@property (strong,nonatomic) NSString *clientSecret;
@property (strong,nonatomic) NSString *codeIdentifier;
@end

@implementation UDPushAuthCodeRetrieverAbstract

#pragma mark -
#pragma mark *** UDPushAuthProcessable ***
#pragma mark -

@synthesize deviceId = _deviceId;
@synthesize redirectURI = _redirectURI;
@synthesize requestDelegate = _requestDelegate;
@synthesize storageDelegate = _storageDelegate;
@synthesize codeDelegate = _codeDelegate;
@synthesize clientCode = _clientCode;
@synthesize clientSecret = _clientSecret;


- (void) registerDeviceWithPushToken:(NSData *)pushToken{    
    if (pushToken != nil) {
        self.storageDelegate.pushToken = pushToken;
        
        __weak __typeof(&*self) weakSelf = self;
        [self.requestDelegate registerDeviceWithPushToken:[self cleanPushToken:pushToken] andCompleteonHandler:^(NSString *deviceID, BOOL isActivated){
            weakSelf.storageDelegate.deviceID = deviceID;
        }];
    }
}

- (void) activationCodeReceived:(NSString *) activationCode{
    
    if (self.storageDelegate.deviceID != nil && activationCode != nil) {
        [self.requestDelegate activateDevice:self.storageDelegate.deviceID WithActivationCode:activationCode CompleteonHandler:^(BOOL activationStatus){
        
        }];
    }
}

- (void) clientSecretReceived:(NSString *)clientSecret withID:(NSString *)secretID{
    if ([self.codeIdentifier isEqualToString:secretID]) {
        self.clientSecret = clientSecret;
    }
}

- (void) pushMessageReceived:(id)pushObject{
    
    if ([pushObject isKindOfClass:[UDPushAuthActivationCode class]]) {
        [self activationCodeReceived:(NSString *)[pushObject objectValue]];
    }
    else if ([pushObject isKindOfClass:[UDPushAuthClientSecret class]]){
        [self clientSecretReceived:(NSString *)[pushObject objectValue] withID:(NSString *)[pushObject secretID]];
    }
}

+ (id) codeRetriever{
    return [[self alloc] init];
}

#pragma mark -
#pragma mark *** UDAuthCodeRetrieverable ***
#pragma mark -

- (void) requestAuthCode{
    
    __weak __typeof(&*self) weakSelf = self;
    
    if (self.storageDelegate.deviceID != nil) {
        [self.requestDelegate authenticateDevice:self.storageDelegate.deviceID WithCompleteonHandler:^(NSString *authCode, NSString *codeIdentifier){
            weakSelf.clientCode = authCode;
            weakSelf.codeIdentifier = codeIdentifier;
        }];
    }
    else {
        [self registerDeviceWithPushToken:self.storageDelegate.pushToken];
    }
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (void) setClientCode:(NSString *)clientCode{
    if (clientCode != nil) {
        _clientCode = clientCode;
    }
}

- (void) setClientSecret:(NSString *)clientSecret{
    if (clientSecret != nil) {
        _clientSecret = clientSecret;
        [self sendCodeToDelegate];
    }
}

- (void) setCodeIdentifier:(NSString *)codeIdentifier{
    if (codeIdentifier !=nil) {
        _codeIdentifier = codeIdentifier;
    }
}

- (NSString *) deviceId{
    return self.storageDelegate.deviceID;
}


- (void) sendCodeToDelegate{
    if (self.clientCode != nil && self.clientSecret != nil) {
        NSString *authCode = [NSString stringWithFormat:@"%@_%@",self.clientCode,self.clientSecret];
        [self.codeDelegate authCodeReceived:authCode forRedirectURI:self.redirectURI];
    }
}

- (NSString *) cleanPushToken:(NSData *) pushToken{
    NSString *resultToken = nil;
    
    resultToken = [NSString stringWithFormat:@"%@",pushToken];
    resultToken = [resultToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    resultToken = [resultToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resultToken;
}

@end
