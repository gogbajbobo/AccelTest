//
//  UDPushAuthHTTPProtocol.h
//  pushauth
//
//  Created by kovtash on 02.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UDPushAuthRequestDelegate <NSObject>
@property (strong,nonatomic) NSURL *uPushAuthServiceURI;
@property (strong,nonatomic) NSString *appID;
- (void) registerDeviceWithPushToken:(NSString *) pushToken andCompleteonHandler:(void ( ^ ) (NSString *deviceID, BOOL isActivated)) completeonHandler;
- (void) activateDevice:(NSString *) deviceID WithActivationCode:(NSString *) activationCode CompleteonHandler:(void ( ^ ) (BOOL activationStatus)) completeonHandler;
- (void) authenticateDevice:(NSString *) deviceID WithCompleteonHandler:(void ( ^ ) (NSString *authCode, NSString * codeIdentifier)) completeonHandler;
@end
