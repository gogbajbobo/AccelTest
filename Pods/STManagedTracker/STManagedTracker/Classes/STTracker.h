//
//  STGTTracker.h
//  geotracker
//
//  Created by Maxim Grigoriev on 3/11/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "STSessionManagement.h"
#import "STManagedDocument.h"

@interface STTracker : NSObject

@property (strong, nonatomic) STManagedDocument *document;
@property (nonatomic, strong) id <STSession> session;
@property (nonatomic) BOOL tracking;
@property (nonatomic, strong) NSMutableDictionary *settings;
@property (nonatomic, strong) NSString *group;
@property (nonatomic) BOOL trackerAutoStart;

- (void)customInit;
- (void)startTracking;
- (void)stopTracking;

@end
