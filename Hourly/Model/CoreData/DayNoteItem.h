//
//  DayNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContentItem, HourNoteItem;

@interface DayNoteItem : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *hourNoteItems;
@property (nonatomic, retain) ContentItem *schedule;
@property (nonatomic, retain) ContentItem *summary;
@end

@interface DayNoteItem (CoreDataGeneratedAccessors)

- (void)addHourNoteItemsObject:(HourNoteItem *)value;
- (void)removeHourNoteItemsObject:(HourNoteItem *)value;
- (void)addHourNoteItems:(NSSet *)values;
- (void)removeHourNoteItems:(NSSet *)values;

@end
