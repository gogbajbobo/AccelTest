//
//  UDAuthCodeRetrieverable.h
//  pushauth
//
//  Created by kovtash on 14.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDAuthCodeRetrieverDelegate.h"

@protocol UDAuthCodeRetrieverable <NSObject>
@property (strong,nonatomic) id <UDAuthCodeRetrieverDelegate> codeDelegate;
- (void) requestAuthCode;
+ (id) codeRetriever;
@end
