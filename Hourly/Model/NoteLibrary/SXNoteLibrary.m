//
//  SXNoteLibrary.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SXNoteLibrary.h"

static SXNoteLibrary* stNoteLibarary = nil;

@implementation SXNoteLibrary

+ (SXNoteLibrary *) sharedNotesLibrary
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stNoteLibarary = [[SXNoteLibrary alloc] init];
    });
    
    return stNoteLibarary;
}

- (void) sync
{
    if (_managedObjectContext != nil)
    {
        NSError* error = nil;
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
        {
            NSLog(@"%s, save failed", __FUNCTION__);
        }
    }
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil)
    {
        NSError* error = nil;
        NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"note.sqlite"]];
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error] == nil)
        {
            NSLog(@"%s failed!", __FUNCTION__);
        }
    }
    return _persistentStoreCoordinator;
}

@end
