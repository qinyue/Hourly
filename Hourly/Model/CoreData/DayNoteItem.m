//
//  DayNoteItem.m
//  Hourly
//
//  Created by 胡少华 on 14-3-7.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "DayNoteItem.h"
#import "ContentItem.h"


@implementation DayNoteItem

@dynamic beginDate;
@dynamic endDate;
@dynamic schedule;
@dynamic summary;

@end

@implementation DayNoteItem (FetchedProperties)

@dynamic hourNotes;
//
//- (NSArray *) hourNotes
//{
//    return [self valueForKey:@"hourNotes"];
//}

@end
