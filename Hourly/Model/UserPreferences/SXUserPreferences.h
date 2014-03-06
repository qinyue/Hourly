//
//  SXUserPreferences.h
//  Hourly
//
//  Created by 胡少华 on 14-3-6.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RecentPeriodUnit)
{
    RecentPeriodUnitDay,
    RecentPeriodUnitWeek,
    RecentPeriodUnitCount
};

#define kPropertyRecentPeriodUnit @"recentPeriodUnit"
#define kPropertyRecentPeriodValue @"recentPeriodValue"
#define kPropertyRecentPeriodChanged @"recentPeriodChanged"

#define kNotificationRecentPeriodChanged @"recentPeriodChanged"

@interface SXUserPreferences : NSObject

@property(nonatomic, readonly) RecentPeriodUnit recentPeriodUnit;
@property(nonatomic, readonly) NSUInteger recentPeriodValue;

+ (SXUserPreferences *) defaultUserPreferences;

- (void) setRecentPeriodUnit:(RecentPeriodUnit)unit withValue:(NSUInteger)value;

- (void) archiveToFile;

@end
