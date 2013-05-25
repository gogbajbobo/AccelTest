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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithDouble:_interval] forKey:@"interval"];
        [defaults synchronize];
    }
}

- (NSTimeInterval)interval {
    if (!_interval) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _interval = [[defaults objectForKey:@"interval"] doubleValue];
        if (!_interval) {
            _interval = 0.01;
            [defaults setObject:[NSNumber numberWithDouble:_interval] forKey:@"interval"];
            [defaults synchronize];
        }
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
            [self.data addObject:motion];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.caller.xLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.x];
                self.caller.yLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.y];
                self.caller.zLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.z];
            });

//            dispatch_queue_t queue = dispatch_queue_create("saveMotion", NULL);
//            dispatch_async(queue, ^{
//                [self addNewData:motion];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.caller.xLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.x];
//                    self.caller.yLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.y];
//                    self.caller.zLabel.text = [NSString stringWithFormat:@"%.2f", motion.userAcceleration.z];
//                });
//            });

        }
    }];
}

- (void)stopTracker {
    [self.tracker stopDeviceMotionUpdates];
    self.caller.data = self.data;
    self.tracking = NO;
}

- (void)addNewData:(CMDeviceMotion *)motion {
    [self.data addObject:motion];
}

@end
