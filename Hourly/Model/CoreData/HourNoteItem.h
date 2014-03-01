//
//  HourNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HourNoteItem : NSManagedObject

@property (nonatomic, retain) NSString * nextStep;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;

@end
