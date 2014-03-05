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
#import "NSDate+String.h"
#import "SXHourNoteCell.h"
#import "SXNoteLibrary.h"
#import "StoryboardUtility.h"


@interface HourNoteCellItem : NSObject
@property(nonatomic, retain) HourNoteItem* noteItem;

@property(nonatomic) CGSize contentSize;
@property(nonatomic, retain) NSString* dateText;

@property(nonatomic, retain) UIFont* dateFont;
@property(nonatomic, retain) UIFont* contentFont;

- (id) initWithNote:(HourNoteItem *)note;

@end

@implementation HourNoteCellItem

- (id) initWithNote:(HourNoteItem *)note
{
    self = [super init];
    if (self)
    {
        self.dateFont = [UIFont systemFontOfSize:18];
        self.contentFont = [UIFont systemFontOfSize:14];
        self.noteItem = note;
        
        self.dateText = [self.noteItem.creationDate descriptionWithFormat:@"HH:mm"];
        [self calculateContentSize];
    }
    return self;
}

- (void) calculateContentSize
{
    CGRect rect = [self.noteItem.content boundingRectWithSize:CGSizeMake(300, 160) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentFont} context:nil];
    self.contentSize = rect.size;
}

@end

@interface SXHourNotesController ()

@property(nonatomic, retain) NSMutableArray* cellItems;

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
    
    [self.tableView registerClass:[SXHourNoteCell class] forCellReuseIdentifier:CellIdentifier];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initCellItems];
}

- (void) initCellItems
{
    self.cellItems = [NSMutableArray array];
    [self resetCellItems];
}

- (void) resetCellItems
{
    [self.cellItems removeAllObjects];
    for (HourNoteItem *item in self.fetchResultsController.fetchedObjects)
    {
        HourNoteCellItem* cellItem = [[HourNoteCellItem alloc] initWithNote:item];
        [self.cellItems addObject:cellItem];
    }
}

- (void) addLastCellItems
{
    HourNoteCellItem* cellItem = [[HourNoteCellItem alloc] initWithNote:self.fetchResultsController.fetchedObjects.lastObject];
    [self.cellItems addObject:cellItem];
}

- (BOOL) updateCellItem:(HourNoteItem *)noteItem atIndex:(NSInteger)row
{
    HourNoteCellItem* cellItem = [self.cellItems objectAtIndex:row];
    CGFloat oldHeight = cellItem.contentSize.height;
    cellItem.noteItem = noteItem;
    [cellItem calculateContentSize];
    return oldHeight != cellItem.contentSize.height;
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
        [self resetCellItems];
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

- (NSString *) fetchResultsCacheName
{
    return @"hour";
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((HourNoteCellItem *)[self.cellItems objectAtIndex:indexPath.row]).contentSize.height + 2 * 6 + 4 + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HourNoteCellItem* item = [self.cellItems objectAtIndex:indexPath.row];
    SXHourNoteCell *cell = (SXHourNoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SXHourNoteCell alloc] initWithReuseId:CellIdentifier];
        cell.textLabel.font = item.dateFont;
        cell.detailTextLabel.font = item.contentFont;
    }
    
//    HourNoteItem* item =[self.fetchResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.creationDate];
    
    
    cell.detailSize = item.contentSize;
    cell.textLabel.text = item.dateText;
    cell.detailTextLabel.text = item.noteItem.content;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HourNoteCellItem* item = [self.cellItems objectAtIndex:indexPath.row];
    SXNoteTextController* notes = [StoryboardUtility noteTextViewController];
    //    NoteTextViewController* notes = [[NoteTextViewController alloc] init];
    notes.noteItem = item.noteItem;
    notes.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:notes animated:YES];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self addLastCellItems];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if ([self updateCellItem:anObject atIndex:indexPath.row])
            {
                [self.tableView reloadData];
            }
            else
            {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            [self.cellItems removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
        default:
            break;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObjectContext* context = [SXNoteLibrary sharedNotesLibrary].managedObjectContext;
        
        
        
        HourNoteCellItem* item = [self.cellItems objectAtIndex:indexPath.row];
        
        [context deleteObject:item.noteItem];
        
        
        
        
        
        
    }
}

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
