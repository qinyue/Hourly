//
//  SXHourNotesController.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXHourNotesController.h"
#import "HourNoteItem.h"
#import "NSObject+String.h"
#import "NSDate+DateComponents.h"

@interface SXHourNotesController ()

@end

@implementation SXHourNotesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

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

- (void) setDayDate:(NSDate *)dayDate
{
    if (![_dayDate isEqualToDate:dayDate])
    {
        _dayDate = dayDate;
        
        [self reloadFetchRequest];
    }
}

- (NSFetchRequest *)fetchRequestForFetchResultsTableController:(SXFetchResultsTableController *)tableController
{
    if (self.dayDate == nil)
    {
        return nil;
    }
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:[HourNoteItem classNameString]];
    request.fetchBatchSize = 20;
    
    NSDate* beginOfDay = [self.dayDate dayDate];
    NSDate* tomorrowDayDate = [self.dayDate tomorrowDate];
    
    NSLog(@"%@,%@", beginOfDay, tomorrowDayDate);
    
    NSPredicate* prdicate = [NSPredicate predicateWithFormat:@"(%K>=%@) AND (%K<=%@)", kPropertyCreationDate, beginOfDay, kPropertyCreationDate, tomorrowDayDate];
    request.predicate = prdicate;
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:kPropertyCreationDate ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    return request;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    HourNoteItem* item = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [item.creationDate description];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
