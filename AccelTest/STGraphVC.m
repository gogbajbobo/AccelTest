//
//  STGraphVC.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STGraphVC.h"
#import "STGraphView.h"

@interface STGraphVC ()
@property (weak, nonatomic) IBOutlet STGraphView *graphView;
@property (nonatomic) CGPoint touchPoint;

@end

@implementation STGraphVC


- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
//        self.graphView.verticalShift += translation.y;
        self.graphView.horizontalShift += translation.x;
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint currentTouchPoint = [gesture locationOfTouch:0 inView:self.graphView];
        CGFloat xDiff = fabs(currentTouchPoint.x - self.touchPoint.x);
        CGFloat yDiff = fabs(currentTouchPoint.y - self.touchPoint.y);
        if (xDiff == 0) {
            self.graphView.yScale *= gesture.scale;
        } else if (yDiff == 0) {
            self.graphView.xScale *= gesture.scale;
        } else {
            [self.graphView changeScale:gesture.scale];
        }
        gesture.scale = 1;
        self.touchPoint = [gesture locationOfTouch:0 inView:self.graphView];
    }
}


- (void)viewInit {
    self.graphView = (STGraphView *)self.view;
    self.graphView.graphData = self.graphData;
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
//    [self.graphView addGestureRecognizer:pinch];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}

#pragma mark - view lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewInit];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
