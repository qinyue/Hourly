//
//  SXNoteTextView.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXNoteTextView.h"

@implementation SXNoteTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addCustomMenuItems];
    }
    return self;
}

- (void) addCustomMenuItems
{
    UIMenuItem* setAsKeyword = [[UIMenuItem alloc] initWithTitle:@"Set As Keyword" action:@selector(setAsKeyword:)];
    
    UIMenuController* menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:[NSArray arrayWithObject:setAsKeyword]];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(setAsKeyword:))
    {
        
    }
    return YES;
}

- (void) setAsKeyword:(id)sender
{
    
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
