//
//  UDAuthTokenRetriever.h
//  pushauth
//
//  Created by kovtash on 15.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import "UDAuthTokenRetrieverAbstract.h"

@interface UDAuthTokenRetriever : UDAuthTokenRetrieverAbstract
- (NSURLRequest *) requestWithResource:(NSString *) resource Parameters:(NSString *) parameters;
+ (id) tokenRetriever;
@end
