//
//  UDAuthToken.m
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthToken.h"
#import "UDMutableAuthToken.h"

@interface UDAuthToken()
@property (nonatomic,strong) NSDate *privateCreationTime;
@end

@implementation UDAuthToken
@synthesize lifetime = _lifetime;
@synthesize value = _value;
@synthesize type = _type;

- (NSDate *) creationTime{
    return self.privateCreationTime;
}

- (NSDate *) expirationTime{
    return [NSDate dateWithTimeInterval:self.lifetime sinceDate:self.privateCreationTime];
}

- (NSTimeInterval) ttl{
    return [self.expirationTime timeIntervalSinceDate:[NSDate date]];
}

- (BOOL) isValid{
    if (self.ttl > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone{
    UDAuthToken *result = [[UDAuthToken allocWithZone:zone] init];
    
    if (result != nil) {
        result->_value = [_value copyWithZone:zone];
        result->_type = _type;
        result->_lifetime = _lifetime;
        result->_privateCreationTime = [_privateCreationTime copyWithZone:zone];
    }    
    return result;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    UDMutableAuthToken *result = [[UDMutableAuthToken allocWithZone:zone] init];
    
    if (result != nil) {
        result.value = [_value copyWithZone:zone];
        result.type = _type;
        result.lifetime = _lifetime;
        result.privateCreationTime = [_privateCreationTime copyWithZone:zone];
    }
    
    return result;
}

#pragma mart - Initialization
- (id) init{
    self = [super init];
    
    if (self != nil) {
        self.privateCreationTime = [NSDate date];
    }
    
    return self;
}

- (id) initWithValue:(NSString *) value Lifetime:(NSTimeInterval) lifetime Type:(UDTokenType) type{
    self = [self init];
    
    if (self != nil){
        _value = value;
        _lifetime = lifetime;
        _type = type;
    }
    
    return self;
}

+ (id) accessTokenWithWalue:(NSString *) value Lifetime:(NSTimeInterval) lifetime{
    return [[[self class] alloc] initWithValue:(NSString *) value Lifetime:(NSTimeInterval) lifetime Type:(UDTokenType) UDAccessTokenType];
}

+ (id) refreshTokenWithWalue:(NSString *) value Lifetime:(NSTimeInterval) lifetime{
    return [[[self class] alloc] initWithValue:(NSString *) value Lifetime:(NSTimeInterval) lifetime Type:(UDTokenType) UDRefreshTokenType];
}

@end
