//
//  UDMutableAuthToken.h
//  pushauth
//
//  Created by kovtash on 22.02.13.
//  Copyright (c) 2013 unact. All rights reserved.
//

#import "UDAuthToken.h"

@interface UDMutableAuthToken : UDAuthToken
@property (strong,nonatomic) NSString *value;
@property (assign,nonatomic) NSTimeInterval lifetime; //in seconds
@property (assign,nonatomic) NSUInteger type;
@end
