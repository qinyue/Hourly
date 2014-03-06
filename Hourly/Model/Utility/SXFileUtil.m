//
//  SXFileUtil.m
//  Hourly
//
//  Created by 胡少华 on 14-3-6.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXFileUtil.h"

@implementation SXFileUtil

+ (NSString *) documentsFilePath
{
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (dirs.count > 0)
    {
        return [dirs objectAtIndex:0];
    }
    return nil;
}

@end
