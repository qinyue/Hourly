//
//  SXNoteLibrary.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HourNoteItem.h"

@interface SXNoteLibrary : NSObject

@property(nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property(nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property(nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (void) sync;

+ (SXNoteLibrary *) sharedNotesLibrary;

- (void) addHourNote:(HourNoteItem *)hourItem;

@end
