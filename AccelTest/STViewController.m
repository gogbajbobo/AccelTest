//
//  STViewController.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STViewController.h"
#import <STManagedTracker/STSession.h>
#import <STManagedTracker/STSessionManager.h>
#import "STMotionTracker.h"
#import "STSet.h"
#import "STAcceleration.h"
#import <CoreMotion/CoreMotion.h>

@interface STViewController ()

@property (nonatomic, strong) STSession *session;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, strong) STMotionTracker *motionTracker;

@end

@implementation STViewController

- (IBAction)startButtonPressed:(id)sender {
    if (self.motionTracker.tracking) {
        [self.motionTracker stopTracker];
        self.startButton.enabled = NO;
        [self getDataFrom:self.motionTracker.data];
        self.startButton.enabled = YES;
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.session.document saveDocument:^(BOOL success) {
            if (success) {
                
            } else {
                NSLog(@"save Not success");
            }
        }];
    } else {
        
        STSet *set = (STSet *)[NSEntityDescription insertNewObjectForEntityForName:@"STSet" inManagedObjectContext:self.session.document.managedObjectContext];
        self.motionTracker.set = set;
        self.motionTracker.interval = 0.01;
        [self.motionTracker startTracker];
        [self.startButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (void)getDataFrom:(NSMutableArray *)data {
    
    for (CMDeviceMotion *motion in data) {
        STAcceleration *acceleration = (STAcceleration *)[NSEntityDescription insertNewObjectForEntityForName:@"STAcceleration" inManagedObjectContext:self.session.document.managedObjectContext];
        acceleration.accelX = [NSNumber numberWithDouble:motion.userAcceleration.x];
        acceleration.accelY = [NSNumber numberWithDouble:motion.userAcceleration.y];
        acceleration.accelZ = [NSNumber numberWithDouble:motion.userAcceleration.z];
        acceleration.timestamp = [NSNumber numberWithDouble:motion.timestamp];
        acceleration.set = self.motionTracker.set;
    }

}

- (void)sessionStarted {
    if ([self.session.status isEqualToString:@"running"]) {
        if (self.motionTracker.tracker.accelerometerAvailable) {
            self.startButton.enabled = YES;
        } else {
            NSLog(@"Accelerometer not available");
        }
    }
}

- (STSession *)session {
    if (!_session) {
        _session = [[STSessionManager sharedManager] currentSession];
    }
    return _session;
}

- (STMotionTracker *)motionTracker {
    if (!_motionTracker) {
        _motionTracker = [[STMotionTracker alloc] init];
    }
    return _motionTracker;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionStatusChanged" object:self.session];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.startButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    self.startButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStarted) name:@"sessionStatusChanged" object:self.session];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
