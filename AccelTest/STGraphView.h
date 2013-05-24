//
//  STGraphView.h
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STGraphView : UIView

@property (nonatomic) CGFloat yScale;
@property (nonatomic) CGFloat xScale;
@property (nonatomic) CGFloat verticalShift;
@property (nonatomic) CGFloat horizontalShift;
@property (nonatomic) CGFloat xyScaleRelation;
@property (nonatomic) NSArray *graphData;

- (void)changeScale:(CGFloat)scale;

@end
