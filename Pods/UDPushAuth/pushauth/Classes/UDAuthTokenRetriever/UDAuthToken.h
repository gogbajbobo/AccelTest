//
//  UDAuthToken.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum UDTokenType{
    UDAccessTokenType = 0,
    UDRefreshTokenType = 1
    } UDTokenType;

@interface UDAuthToken : NSObject
@property (readonly,nonatomic) NSString *value;
@property (readonly,nonatomic) NSTimeInterval lifetime; //in seconds
@property (readonly,nonatomic) UDTokenType type;
@property (readonly,nonatomic) NSDate *creationTime;
@property (readonly,nonatomic) NSTimeInterval ttl;
@property (readonly,nonatomic) NSDate *expirationTime;
@property (readonly,nonatomic) BOOL isValid;

- (id) initWithValue:(NSString *) value Lifetime:(NSTimeInterval) lifetime Type:(UDTokenType) type;
+ (id) accessTokenWithWalue:(NSString *) value Lifetime:(NSTimeInterval) lifetime;
+ (id) refreshTokenWithWalue:(NSString *) value Lifetime:(NSTimeInterval) lifetime;
@end
