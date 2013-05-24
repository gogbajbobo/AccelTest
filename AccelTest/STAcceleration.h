//
//  STAcceleration.h
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STDatum.h"

@class STSet;

@interface STAcceleration : STDatum

@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * accelX;
@property (nonatomic, retain) NSNumber * accelY;
@property (nonatomic, retain) NSNumber * accelZ;
@property (nonatomic, retain) STSet *set;

@end
