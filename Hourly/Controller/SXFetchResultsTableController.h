//
//  SXFetchResultsTableController.h
//  Hourly
//
//  Created by 胡少华 on 14-3-3.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SXFetchResultsTableController;

@protocol SXFetchResultsDataSource <NSFetchedResultsControllerDelegate>

- (NSFetchRequest *) fetchRequestForFetchResultsTableController:(SXFetchResultsTableController *)tableController;

- (NSString *) fetchResultsCacheName;

@end

@interface SXFetchResultsTableController : UITableViewController<SXFetchResultsDataSource>

@property(nonatomic, readonly) NSFetchedResultsController* fetchResultsController;

- (void) reloadFetchRequest;

@end
