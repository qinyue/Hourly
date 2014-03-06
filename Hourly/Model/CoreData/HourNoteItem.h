//
//  HourNoteItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-7.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kPropertyCreationDate @"creationDate"


@interface HourNoteItem : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * nextStep;
@property (nonatomic, retain) NSNumber * weight;

@end
