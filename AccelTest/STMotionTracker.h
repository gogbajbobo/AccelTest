//
//  STMotionTracker.h
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "STSet.h"

@interface STMotionTracker : NSObject

@property (nonatomic, strong) CMMotionManager *tracker;
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic) BOOL tracking;
@property (nonatomic, strong) STSet *set;
@property (nonatomic, strong) NSMutableArray *data;

- (void)startTracker;
- (void)stopTracker;

@end
