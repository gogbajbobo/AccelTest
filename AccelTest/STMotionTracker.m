//
//  STMotionTracker.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STMotionTracker.h"
#import <STManagedTracker/STSessionManager.h>
#import <STManagedTracker/STManagedDocument.h>
#import "STAcceleration.h"

@interface STMotionTracker()

@property (nonatomic, strong) STManagedDocument *document;

@end

@implementation STMotionTracker

@synthesize interval = _interval;

- (CMMotionManager *)tracker {
    if (!_tracker) {
        _tracker = [[CMMotionManager alloc] init];
    }
    return _tracker;
}

- (void)setInterval:(NSTimeInterval)interval {
    if (interval != _interval) {
        _interval = interval;
        self.tracker.deviceMotionUpdateInterval = _interval;
    }
}

- (NSTimeInterval)interval {
    if (!_interval) {
        _interval = 0.01;
    }
    return _interval;
}

- (STManagedDocument *)document {
    if (!_document) {
        _document = [[[STSessionManager sharedManager] currentSession] document];
    }
    return _document;
}

- (void)startTracker {
    self.data = [NSMutableArray array];
//    [self.data removeAllObjects];
    self.tracker.deviceMotionUpdateInterval = self.interval;
    self.tracking = YES;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [self.tracker startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
//        NSLog(@"1 %.2f", [NSDate timeIntervalSinceReferenceDate]);
        if (error) {
            NSLog(@"Start motion update error %@", error);
            [self.tracker stopDeviceMotionUpdates];
            self.tracking = NO;
        } else {
            [self addNewData:motion];
        }
    }];
}

- (void)stopTracker {
    [self.tracker stopDeviceMotionUpdates];
    self.tracking = NO;
}

- (void)addNewData:(CMDeviceMotion *)motion {
    [self.data addObject:motion];
}

@end
