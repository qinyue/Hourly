//
//  NSDate+String.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

- (NSString *) descriptionWithFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:self];
}

@end
