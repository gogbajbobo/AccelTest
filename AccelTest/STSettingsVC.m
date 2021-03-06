//
//  STSettingsVC.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/24/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STSettingsVC.h"

@interface STSettingsVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *axisSelector;
@property (weak, nonatomic) IBOutlet UISlider *lenghtSlider;
@property (weak, nonatomic) IBOutlet UILabel *lenghtLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dataSelector;

@end

@implementation STSettingsVC

- (IBAction)dataSelect:(id)sender {
    
    if (sender == self.dataSelector) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInteger:self.dataSelector.selectedSegmentIndex] forKey:@"dataSelector"];
        [defaults synchronize];
    }
    
}

- (IBAction)typeSelect:(id)sender {
    if (sender == self.typeSelector) {
        if (self.typeSelector.selectedSegmentIndex == 0) {
            self.axisSelector.enabled = YES;
            [self.caller.settings setValue:@"single" forKey:@"type"];
        } else {
            self.axisSelector.enabled = NO;
            [self.caller.settings setValue:@"all" forKey:@"type"];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.caller.settings valueForKey:@"type"] forKey:@"type"];
        [defaults synchronize];
    }
}

- (IBAction)axisSelect:(id)sender {
    if (sender == self.axisSelector) {
        if (self.axisSelector.selectedSegmentIndex == 0) {
            [self.caller.settings setValue:@"X" forKey:@"axis"];
        } else if (self.axisSelector.selectedSegmentIndex == 1) {
            [self.caller.settings setValue:@"Y" forKey:@"axis"];
        } else if (self.axisSelector.selectedSegmentIndex == 2) {
            [self.caller.settings setValue:@"Z" forKey:@"axis"];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.caller.settings valueForKey:@"axis"] forKey:@"axis"];
        [defaults synchronize];
    }
}

- (IBAction)lenghtValueChanged:(id)sender {
    if (sender == self.lenghtSlider) {
        self.lenghtSlider.value = rint(self.lenghtSlider.value / 10) * 10;
        self.lenghtLabel.text = [NSString stringWithFormat:@"%.f", self.lenghtSlider.value];
        [self.caller.settings setValue:[NSNumber numberWithDouble:self.lenghtSlider.value] forKey:@"lenght"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithDouble:self.lenghtSlider.value] forKey:@"lenght"];
        [defaults synchronize];
    }
}


- (void)dataSelectorSetup {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"dataSelector"];
    if (!value) {
        value = 0;
        [defaults setObject:value forKey:@"dataSelector"];
        [defaults synchronize];
    }
    self.dataSelector.selectedSegmentIndex = [value integerValue];
}


- (void)viewInit {

    if ([[self.caller.settings valueForKey:@"type"] isEqualToString:@"all"]) {
        self.typeSelector.selectedSegmentIndex = 1;
        self.axisSelector.enabled = NO;
    } else {
        self.typeSelector.selectedSegmentIndex = 0;
        self.axisSelector.enabled = YES;
    }
    
    if ([[self.caller.settings valueForKey:@"axis"] isEqualToString:@"X"]) {
        self.axisSelector.selectedSegmentIndex = 0;
    } else if ([[self.caller.settings valueForKey:@"axis"] isEqualToString:@"Y"]) {
        self.axisSelector.selectedSegmentIndex = 1;
    } else if ([[self.caller.settings valueForKey:@"axis"] isEqualToString:@"Z"]) {
        self.axisSelector.selectedSegmentIndex = 2;
    }
    
    [self dataSelectorSetup];
    
    self.lenghtSlider.value = [[self.caller.settings valueForKey:@"lenght"] doubleValue];
    self.lenghtLabel.text = [NSString stringWithFormat:@"%.f", self.lenghtSlider.value];
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
