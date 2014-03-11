//
//  WeekNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-8.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, DayNoteItem;

@interface WeekNoteItem : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet *days;
@property (nonatomic, retain) ContentItem *schedule;
@property (nonatomic, retain) ContentItem *summary;
@end

@interface WeekNoteItem (CoreDataGeneratedAccessors)

- (void)addDaysObject:(DayNoteItem *)value;
- (void)removeDaysObject:(DayNoteItem *)value;
- (void)addDays:(NSSet *)values;
- (void)removeDays:(NSSet *)values;

@end
