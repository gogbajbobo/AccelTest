//
//  STLogMessage.h
//  STManagedTracker
//
//  Created by Maxim Grigoriev on 5/14/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STDatum.h"


@interface STLogMessage : STDatum

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;

@end
