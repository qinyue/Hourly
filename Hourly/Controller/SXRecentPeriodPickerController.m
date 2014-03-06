//
//  SXRecentPeriodPickerController.m
//  Hourly
//
//  Created by 胡少华 on 14-3-6.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXRecentPeriodPickerController.h"
#import "SXUserPreferences.h"

@interface RecentConfigCellItem : NSObject

//@property(nonatomic) NSUInteger unit;
@property(nonatomic) NSInteger value;
@property(nonatomic, strong) NSString* title;

@end

@implementation RecentConfigCellItem


@end

#pragma mark -

#define kDaySectionRows 6
#define kWeekSectionRows 3

#define kAlertViewTagCustomWeeks 1024
#define kAlertViewTagCustomDays 1025

#define kCellItemTitleCustom @"Custom..."
#define kCellItemTitleCustomDays @"Custom  <Last %lu days>"
#define kCellItemTitleCustomWeeks @"Custom  <Last %lu weeks>"

NSString* const daySectionTitle[kDaySectionRows] = {@"Yesteday", @"Last 2 days", @"Last 3 days", @"Last 5 days", @"Last 7 days", kCellItemTitleCustom};
const NSInteger daySectionRowValue[kDaySectionRows] = {1, 2, 3, 5, 7, 0};

NSString* const weekSectionTitle[kWeekSectionRows] = {@"This Week", @"Last 2 weeks", kCellItemTitleCustom};
const NSUInteger weekSectionRowValue[kWeekSectionRows] = {1, 2, 0};

@interface SXRecentPeriodPickerController ()

@property(nonatomic, strong) NSArray* cellItems;

@property(nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation SXRecentPeriodPickerController



- (void) initCellItems
{
    NSMutableArray* dayItems = [NSMutableArray arrayWithCapacity:kDaySectionRows];
    for (NSInteger idx = 0; idx < kDaySectionRows; ++idx) {
        RecentConfigCellItem* item = [[RecentConfigCellItem alloc] init];
        item.value = daySectionRowValue[idx];
        item.title = daySectionTitle[idx];
        [dayItems addObject:item];
    }
    
    NSMutableArray* weekItems = [NSMutableArray arrayWithCapacity:kWeekSectionRows];
    for (NSInteger idx = 0; idx < kWeekSectionRows; ++idx) {
        RecentConfigCellItem* item = [[RecentConfigCellItem alloc] init];
        item.value = weekSectionRowValue[idx];
        item.title = weekSectionTitle[idx];
        [weekItems addObject:item];
    }
    
    self.cellItems = [NSArray arrayWithObjects:dayItems, weekItems, nil];
    
    SXUserPreferences* pref = [SXUserPreferences defaultUserPreferences];
    NSArray* items = [self.cellItems objectAtIndex:pref.recentPeriodUnit];
    switch (pref.recentPeriodUnit) {
        case RecentPeriodUnitDay:
            [self resetDayCellItems:items WithValue:pref.recentPeriodValue];
            break;
        case RecentPeriodUnitWeek:
            [self resetWeekCellItems:items WithValue:pref.recentPeriodValue];
            break;
            
        default:
            break;
    }
}

- (void) resetDayCellItems:(NSArray *)items WithValue:(NSUInteger)dayValue
{
    RecentConfigCellItem* item = nil;
    for (NSInteger idx = 0; idx < kDaySectionRows - 1; ++idx)
    {
        if (daySectionRowValue[idx] == dayValue)
        {
            self.selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            return;
        }
    }
    item = items.lastObject;
    item.value = dayValue;
    item.title = [NSString stringWithFormat:kCellItemTitleCustomDays, dayValue];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:kDaySectionRows - 1 inSection:0];
}

- (void) resetWeekCellItems:(NSArray *)items WithValue:(NSUInteger)weekValue
{
    RecentConfigCellItem* item = nil;
    for (NSInteger idx = 0; idx < kWeekSectionRows - 1; ++idx)
    {
        if (weekSectionRowValue[idx] == weekValue)
        {
            self.selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:1];
            return;
        }
    }
    item = items.lastObject;
    item.value = weekValue;
    item.title = [NSString stringWithFormat:kCellItemTitleCustomWeeks, weekValue];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:kWeekSectionRows - 1 inSection:1];
}

- (NSUInteger) indexWithValue:(NSInteger)value inCellItems:(NSArray *)items
{
    NSInteger idx = [items indexOfObjectPassingTest:^(id object, NSUInteger idx, BOOL* stop){
        if (((RecentConfigCellItem *)object).value == value)
        {
            *stop = YES;
            return  YES;
        }
        return NO;
    }];
    return idx != NSNotFound ? idx : items.count - 1;
}

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
    

    [self initCellItems];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return RecentPeriodUnitCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? kDaySectionRows : kWeekSectionRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RecentConfigCellItem* item = [[self.cellItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.accessoryType = [indexPath isEqual:self.selectedIndexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 0 ? @"day" : @"week");
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ((indexPath.section == RecentPeriodUnitDay && indexPath.row < kDaySectionRows - 1)
        || (indexPath.section == RecentPeriodUnitWeek && indexPath.row < kWeekSectionRows - 1))
    {
        [self resetNewSelectedIndexPath:indexPath values:0 titleFormat:@""];
    }
    else if (indexPath.section == RecentPeriodUnitDay)
    {
        [self showAlertViewForCustomDays];
    }
    else if (indexPath.section == RecentPeriodUnitWeek)
    {
        [self showAlertViewForCustomWeeks];
    }
}

- (void) resetNewSelectedIndexPath:(NSIndexPath *)indexPath values:(NSInteger)value titleFormat:(NSString *)titleFormat
{
    RecentConfigCellItem* oldItem = [[self.cellItems objectAtIndex:self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
    UITableViewCell* oldCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    if (self.selectedIndexPath.row + 1 == [[self.cellItems objectAtIndex:self.selectedIndexPath.section] count])
    {
        oldItem.value = 0;
        oldItem.title = oldCell.textLabel.text = kCellItemTitleCustom;
    }
    
    UITableViewCell* newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath;
    RecentConfigCellItem* newItem = [[self.cellItems objectAtIndex:self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
    if (self.selectedIndexPath.row + 1 == [[self.cellItems objectAtIndex:self.selectedIndexPath.section] count])
    {
        newItem.value = value;
        newItem.title = newCell.textLabel.text = [NSString stringWithFormat:titleFormat, value];
    }
}



- (void) showAlertViewWithTitle:(NSString *)title message:(NSString *)msg tag:(NSInteger)tag
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertView.tag = tag;
    
    UITextField* textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView show];
}

- (void) showAlertViewForCustomDays
{
    [self showAlertViewWithTitle:@"custom days" message:@"Want view last days:" tag:kAlertViewTagCustomDays];
}

- (void) showAlertViewForCustomWeeks
{
    [self showAlertViewWithTitle:@"custom weeks" message:@"Want view last weeks:" tag:kAlertViewTagCustomWeeks];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UITextField* textField = [alertView textFieldAtIndex:0];
        if (alertView.tag == kAlertViewTagCustomDays)
        {
            NSInteger days = [textField.text integerValue];
            if (days > 0)
            {
                [self resetNewSelectedIndexPath:[NSIndexPath indexPathForRow:[self indexWithValue:days inCellItems:[self.cellItems objectAtIndex:RecentPeriodUnitDay]] inSection:RecentPeriodUnitDay] values:days titleFormat:kCellItemTitleCustomDays];
            }
            
        }
        else if (alertView.tag == kAlertViewTagCustomWeeks)
        {
            NSInteger weeks = [textField.text integerValue];
            if (weeks > 0)
            {
                [self resetNewSelectedIndexPath:[NSIndexPath indexPathForRow:[self indexWithValue:weeks inCellItems:[self.cellItems objectAtIndex:RecentPeriodUnitWeek]] inSection:RecentPeriodUnitWeek] values:weeks titleFormat:kCellItemTitleCustomWeeks];
            }
        }
    }
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)doneButtonClicked:(id)sender
{
    RecentConfigCellItem* newItem = [[self.cellItems objectAtIndex:self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
    [[SXUserPreferences defaultUserPreferences] setRecentPeriodUnit:self.selectedIndexPath.section withValue:newItem.value];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
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
