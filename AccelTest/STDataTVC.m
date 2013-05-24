//
//  STDataTVC.m
//  AccelTest
//
//  Created by Maxim Grigoriev on 5/23/13.
//  Copyright (c) 2013 Maxim Grigoriev. All rights reserved.
//

#import "STDataTVC.h"
#import <CoreData/CoreData.h>
#import "STSet.h"
#import "STAcceleration.h"
#import <STManagedTracker/STSession.h>
#import <STManagedTracker/STSessionManager.h>
#import "STGraphVC.h"
#import "STSettingsVC.h"
#import <STManagedTracker/STQueue.h>

@interface STDataTVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) STSession *session;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end

@implementation STDataTVC

- (NSMutableDictionary *)settings {
    if (!_settings) {
        _settings = [NSMutableDictionary dictionary];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *type = [defaults objectForKey:@"type"];
        if (!type) {
            type = @"all";
            [defaults setObject:type forKey:@"type"];
            [defaults synchronize];
        }
        [_settings setValue:type forKey:@"type"];

        NSString *axis = [defaults objectForKey:@"axis"];
        if (!axis) {
            axis = @"X";
            [defaults setObject:axis forKey:@"axis"];
            [defaults synchronize];
        }
        [_settings setValue:axis forKey:@"axis"];
        
        NSNumber *lenght = [defaults objectForKey:@"lenght"];
        if (!lenght) {
            lenght = [NSNumber numberWithInt:10];
            [defaults setObject:lenght forKey:@"lenght"];
            [defaults synchronize];
        }
        [_settings setValue:lenght forKey:@"lenght"];
    }
    return _settings;
}

- (IBAction)settingsButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showSettings" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGraph"] && [sender isKindOfClass:[STSet class]]) {
        if ([segue.destinationViewController isKindOfClass:[STGraphVC class]]) {
            STSet *set = (STSet *)sender;
            [(STGraphVC *)segue.destinationViewController setGraphData:[self dataForGraphFrom:set]];
        }
    } else if ([segue.identifier isEqualToString:@"showSettings"]) {
        if ([segue.destinationViewController isKindOfClass:[STSettingsVC class]]) {
            [(STSettingsVC *)segue.destinationViewController setCaller:self];
        }
        
    }
}

- (NSArray *)dataForGraphFrom:(STSet *)dataSet {
    NSMutableArray *graphData = [NSMutableArray array];
    
    NSInteger lenght = [[self.settings valueForKey:@"lenght"] integerValue];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES selector:@selector(compare:)];
    NSArray *accelData = [dataSet.accelerations sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    if ([[self.settings valueForKey:@"type"] isEqualToString:@"all"]) {

        STQueue *xQueue = [[STQueue alloc] init];
        STQueue *yQueue = [[STQueue alloc] init];
        STQueue *zQueue = [[STQueue alloc] init];
        xQueue.queueLength = lenght;
        yQueue.queueLength = lenght;
        zQueue.queueLength = lenght;

        for (STAcceleration *accelDatum in accelData) {
            
            [xQueue enqueue:accelDatum.accelX];
            [yQueue enqueue:accelDatum.accelY];
            [zQueue enqueue:accelDatum.accelZ];
            
            if (xQueue.filled) {
                double meanX = [self meanValueFor:xQueue];
                double meanY = [self meanValueFor:yQueue];
                double meanZ = [self meanValueFor:zQueue];

                double mean = sqrt(pow(meanX, 2) + pow(meanY, 2) + pow(meanZ, 2));
                
                [graphData addObject:[NSNumber numberWithDouble:mean]];
            }
            
        }

    } else if ([[self.settings valueForKey:@"type"] isEqualToString:@"single"]) {
        
        STQueue *dataQueue = [[STQueue alloc] init];
        dataQueue.queueLength = lenght;

        NSString *axis = [NSString stringWithFormat:@"accel%@", [self.settings valueForKey:@"axis"]];
        
        for (STAcceleration *accelDatum in accelData) {
            [dataQueue enqueue:[accelDatum valueForKey:axis]];
            if (dataQueue.filled) {
                [graphData addObject:[NSNumber numberWithDouble:[self meanValueFor:dataQueue]]];
            }
        }

    }

    return graphData;
}

- (double)meanValueFor:(NSArray *)data {
    double sum = 0;
    for (NSNumber *value in data) {
        sum += [value doubleValue];
    }
    return sum / data.count;
}


- (STSession *)session {
    if (!_session) {
        _session = [[STSessionManager sharedManager] currentSession];
    }
    return _session;
}

- (NSFetchedResultsController *)resultsController {
    if (!_resultsController) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"STSet"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"cts" ascending:NO selector:@selector(compare:)]];
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.session.document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _resultsController.delegate = self;
    }
    return _resultsController;
}

- (void)performFetch {
    NSError *error;
    if (![self.resultsController performFetch:&error]) {
        NSLog(@"performFetch error %@", error);
    } else {
        
    }
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performFetch];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:indexPath.section];
    STSet *set = (STSet *)[[sectionInfo objects] objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", set.cts];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", set.accelerations.count];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:indexPath.section];
    STSet *set = (STSet *)[[sectionInfo objects] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showGraph" sender:set];
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.resultsController sections] objectAtIndex:indexPath.section];
    STSet *set = (STSet *)[[sectionInfo objects] objectAtIndex:indexPath.row];
    [self.session.document.managedObjectContext deleteObject:set];
    
}


#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //    NSLog(@"controllerDidChangeContent");
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    //    NSLog(@"controller didChangeObject");
    
    if ([[(STSession *)self.session status] isEqualToString:@"running"]) {
        
        
        if (type == NSFetchedResultsChangeDelete) {
            
            //        NSLog(@"NSFetchedResultsChangeDelete");
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            
        } else if (type == NSFetchedResultsChangeInsert) {
            
            //        NSLog(@"NSFetchedResultsChangeInsert");
            
//            [self.tableView reloadData];
            //        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            
        } else if (type == NSFetchedResultsChangeUpdate) {
            
            //        NSLog(@"NSFetchedResultsChangeUpdate");
            
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }
}


@end
