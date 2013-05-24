//
//  STMovementAnalyzer.h
//  HippoTracker
//
//  Created by Maxim Grigoriev on 5/18/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "STQueue.h"
#import "STSessionManagement.h"


@interface STMovementAnalyzer : NSObject

@property (nonatomic, strong) id <STSession> sesstion;
@property (nonatomic, strong) STQueue *locationsQueue;
@property (nonatomic, strong) STQueue *accelerometerQueue;
@property (nonatomic) BOOL GPSMovingDetected;
@property (nonatomic) CLLocationDistance startSpeedThreshold;
@property (nonatomic) CLLocationDistance finishSpeedThreshold;


- (void)addLocation:(CLLocation *)location;

@end
