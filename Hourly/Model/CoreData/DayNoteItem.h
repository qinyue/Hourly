//
//  DayNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-7.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HourNoteItem;
@class ContentItem;

@interface DayNoteItem : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) ContentItem *schedule;
@property (nonatomic, retain) ContentItem *summary;

@end

@interface DayNoteItem (FetchedProperties)

@property(nonatomic, retain) NSArray* hourNotes;

@end
