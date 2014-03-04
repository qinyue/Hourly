//
//  StoryboardUtility.m
//  TabHour
//
//  Created by 胡少华 on 14-2-23.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "StoryboardUtility.h"


@implementation StoryboardUtility

+ (UIViewController *) viewController:(NSString *)storyboardID forStoryBoard:(NSString *)storyboardName
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:storyboardID];
}

+ (SXNoteTextController *) noteTextViewController
{
    return (SXNoteTextController *)[self viewController:@"NoteTextViewController" forStoryBoard:@"Main"];
}

//+ (HoursViewController *) hoursViewController
//{
//    return (HoursViewController *)[self viewController:@"HoursViewController" forStoryBoard:@"Main"];
//}

@end
