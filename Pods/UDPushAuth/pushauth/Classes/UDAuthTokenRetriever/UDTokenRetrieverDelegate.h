//
//  UDTokenRetrieverDelegate.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDAuthToken.h"

@protocol UDTokenRetrieverDelegate <NSObject>
- (void) tokenReceived:(UDAuthToken *) token;
@end
