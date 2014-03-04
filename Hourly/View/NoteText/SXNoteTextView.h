//
//  SXNoteTextView.h
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXNoteTextView;

@protocol SXNoteTextViewDelegate <UITextViewDelegate>

@optional
- (void) setAsKeywordForNoteTextView:(SXNoteTextView *)noteTextView;

@end

@interface SXNoteTextView : UITextView

@end
