//
//  DayNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-8.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, HourNoteItem, WeekNoteItem;

@interface DayNoteItem : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet *hours;
@property (nonatomic, retain) ContentItem *schedule;
@property (nonatomic, retain) ContentItem *summary;
@property (nonatomic, retain) WeekNoteItem *week;
@end

@interface DayNoteItem (CoreDataGeneratedAccessors)

- (void)addHoursObject:(HourNoteItem *)value;
- (void)removeHoursObject:(HourNoteItem *)value;
- (void)addHours:(NSSet *)values;
- (void)removeHours:(NSSet *)values;

@end
