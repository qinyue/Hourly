//
//  StoryboardUtility.h
//  TabHour
//
//  Created by 胡少华 on 14-2-23.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXNoteTextController.h"


@interface StoryboardUtility : NSObject

+ (UIViewController *) viewController:(NSString *)storyboardID forStoryBoard:(NSString *)storyboardName;

+ (SXNoteTextController *) noteTextViewController;


@end
