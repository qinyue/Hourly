//
//  SXUserPreferences.m
//  Hourly
//
//  Created by 胡少华 on 14-3-6.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXUserPreferences.h"
#import "SXFileUtil.h"

static SXUserPreferences* stDefaultUserPreferences = nil;

@interface SXUserPreferences ()

@property(nonatomic, strong) NSMutableDictionary* dict;

@property(nonatomic) RecentPeriodUnit recentPeriodUnit;
@property(nonatomic) NSUInteger recentPeriodValue;
@property(nonatomic) BOOL recentPeriodChanged;

@end

#define kUserPreferencesFileName @"user_pref"

@implementation SXUserPreferences

+ (SXUserPreferences *) defaultUserPreferences
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stDefaultUserPreferences = [[super allocWithZone:NULL] init];
        //        stDefaultUserConfiguration = [[UserConfiguration alloc] init];
    });
    
    return stDefaultUserPreferences;
}

- (NSString *)archivedFilePath
{
    return [[SXFileUtil documentsFilePath] stringByAppendingPathComponent:kUserPreferencesFileName];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.dict = [NSMutableDictionary dictionaryWithContentsOfFile:[self archivedFilePath]];
        if (self.dict == nil)
        {
            self.dict = [[NSMutableDictionary alloc] init];
            
            [self initDefaultConfigurations];
        }
        else
        {
            [self initConfigurations];
        }
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id) allocWithZone:(struct _NSZone *)zone
{
    return [self defaultUserPreferences];
}

- (void) initConfigurations
{
    self.recentPeriodUnit = [[self.dict objectForKey:kPropertyRecentPeriodUnit] unsignedIntegerValue];
    self.recentPeriodValue = [[self.dict objectForKey:kPropertyRecentPeriodValue] unsignedIntegerValue];
}

- (void) initDefaultConfigurations
{
    self.recentPeriodUnit = RecentPeriodUnitDay;
    self.recentPeriodValue = 7;
}

- (void) setRecentPeriodUnit:(RecentPeriodUnit)unit withValue:(NSUInteger)value
{
    if (unit != self.recentPeriodUnit || value != self.recentPeriodValue)
    {
        self.recentPeriodUnit = unit;
        self.recentPeriodValue = value;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecentPeriodChanged object:nil];
    }
}

- (void) archiveToFile
{
    [self.dict setObject:[NSNumber numberWithUnsignedInteger:self.recentPeriodUnit] forKey:kPropertyRecentPeriodUnit];
    [self.dict setObject:[NSNumber numberWithUnsignedInteger:self.recentPeriodValue] forKey:kPropertyRecentPeriodValue];
    
    BOOL save = [self.dict writeToFile:[self archivedFilePath] atomically:YES];
    NSLog(@"save %@", save ? @"success" : @"faile");
}

@end
