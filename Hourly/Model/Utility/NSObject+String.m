//
//  NSObject+String.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "NSObject+String.h"

@implementation NSObject (String)

+ (NSString *) classNameString
{
    return NSStringFromClass([self class]);
}

@end
