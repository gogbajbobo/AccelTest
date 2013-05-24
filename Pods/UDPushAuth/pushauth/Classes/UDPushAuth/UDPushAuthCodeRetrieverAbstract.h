//
//  UDDeviceIDHandler.h
//  pushauth
//
//  Created by kovtash on 01.11.12.
//  Copyright (c) 2012 unact. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDPushAuthProcessableProtocol.h"
#import "UDAuthCodeRetrieverableProtocol.h"

@interface UDPushAuthCodeRetrieverAbstract : NSObject <UDPushAuthProcessable,UDAuthCodeRetrieverable>
@end
