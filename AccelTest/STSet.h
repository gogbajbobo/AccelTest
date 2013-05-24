//
//  STSet.h
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STDatum.h"

@class STAcceleration;

@interface STSet : STDatum

@property (nonatomic, retain) NSSet *accelerations;
@end

@interface STSet (CoreDataGeneratedAccessors)

- (void)addAccelerationsObject:(STAcceleration *)value;
- (void)removeAccelerationsObject:(STAcceleration *)value;
- (void)addAccelerations:(NSSet *)values;
- (void)removeAccelerations:(NSSet *)values;

@end
