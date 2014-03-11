//
//  ContentItem.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContentItem : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSDate * lastModificationDate;

@end
