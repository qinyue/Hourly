//
//  WeekNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, DayNoteItem;

@interface WeekNoteItem : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) ContentItem *schedule;
@property (nonatomic, retain) ContentItem *summary;
@property (nonatomic, retain) NSSet *dayNoteItems;
@end

@interface WeekNoteItem (CoreDataGeneratedAccessors)

- (void)addDayNoteItemsObject:(DayNoteItem *)value;
- (void)removeDayNoteItemsObject:(DayNoteItem *)value;
- (void)addDayNoteItems:(NSSet *)values;
- (void)removeDayNoteItems:(NSSet *)values;

@end
