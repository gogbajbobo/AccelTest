//
//  STViewController.h
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (nonatomic, strong) NSArray *data;

@end
