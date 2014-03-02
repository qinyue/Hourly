//
//  SXNoteTextController.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "HourNoteItem.h"
#import "NSDate+String.h"
#import "SXNoteLibrary.h"
#import "SXNoteTextView.h"
#import "NSObject+String.h"
#import "SXNoteTextController.h"

#define kTextViewMargin 8

@interface SXNoteTextController ()<UIGestureRecognizerDelegate, SXNoteTextViewDelegate>

@property (strong, nonatomic) UITextView *noteTextView;
@property (nonatomic) CGFloat lastKeyboardHeight;
@property (nonatomic) CGFloat maxTextViewHeight;

@property(nonatomic, strong) UIBarButtonItem* editBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem* saveBarButtonItem;

@end

@implementation SXNoteTextController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.noteTextView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    [self addKeyBoardNotifications];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configTapGesture];
    
    [self initNoteTextView];
    
    
    [self configIfNoteItem];
}

- (void) initNoteTextView
{
    CGRect navigationFrame = self.navigationController.navigationBar.frame;
    self.noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, navigationFrame.size.height + navigationFrame.origin.y + kTextViewMargin, 300, 48)];
    self.noteTextView.font = [UIFont systemFontOfSize:18];
    self.noteTextView.delegate = self;
    self.noteTextView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:self.noteTextView];
    
    self.noteTextView.delegate = self;
    [self.noteTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self resetMaxTextViewHeight];
}

- (void) setNoteItem:(HourNoteItem *)noteItem
{
    if (noteItem != _noteItem)
    {
        _noteItem  = noteItem;
        
        if ([self isViewLoaded])
        {
            [self configIfNoteItem];
        }
    }
}

- (void) ensureEditBarButtonItem
{
    if (self.editBarButtonItem == nil)
    {
        self.editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
    }
}

- (void) ensureSaveBarButtonItem
{
    if (self.saveBarButtonItem == nil)
    {
        self.saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClickedForUpdate:)];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void) configIfNoteItem
{
    NSString* dayString = nil;
    if (self.noteItem != nil)
    {
        self.noteTextView.text = self.noteItem.content;
        self.noteTextView.editable = NO;
        
        [self ensureEditBarButtonItem];
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem;
        
        self.navigationItem.title = [self.noteItem.creationDate descriptionWithFormat:@"HH:mm"];
        dayString = [self.noteItem.creationDate descriptionWithFormat:@"yyyy-MM-dd"];
    }
    else
    {
        UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked:)];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
        UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonClickedForInsert:)];
        self.navigationItem.rightBarButtonItem = rightButtonItem;
        self.navigationItem.title = @"New Note";
        
        dayString = [[NSDate date] descriptionWithFormat:@"yyyy-MM-dd"];
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = dayString;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    UIBarButtonItem* dayItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    UIBarButtonItem* closeKeyboardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopButtonClicked:)];
    self.toolbarItems = [NSArray arrayWithObjects:closeKeyboardButton, dayItem, nil];
}

- (void) editButtonClicked:(id)sender
{
    self.noteTextView.editable = YES;
    [self.noteTextView becomeFirstResponder];
    [self ensureSaveBarButtonItem];
    self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
}

- (void) saveButtonClickedForUpdate:(id)sender
{
    self.noteTextView.editable = NO;
    [self.noteTextView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = self.editBarButtonItem;
    
    self.noteItem.content = self.noteTextView.text;
    
}

- (void) resetMaxTextViewHeight
{
    self.maxTextViewHeight = self.navigationController.toolbar.frame.origin.y /*- (self.noteTextView.frame.origin.y - self.navigationController.navigationBar.frame.size.height)*/ - self.noteTextView.frame.origin.y;
}

- (void) addKeyBoardNotifications
{
    NSNotificationCenter* notify = [NSNotificationCenter defaultCenter];
    [notify addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notify addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [notify addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) relayoutToolBar
{
    UIToolbar* toolbar = self.navigationController.toolbar;
    CGRect toolbarFrame = toolbar.frame;
    toolbarFrame.origin.y = self.navigationController.view.frame.size.height - self.lastKeyboardHeight - toolbar.frame.size.height;
    toolbar.frame = toolbarFrame;
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    [self keyboardFrameChanged:notification];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    self.lastKeyboardHeight = 0;
    [self relayoutToolBar];
    [self resetMaxTextViewHeight];
    
    CGRect frame = self.noteTextView.frame;
    CGSize contentSize = self.noteTextView.contentSize;
    if (contentSize.height > self.maxTextViewHeight)
    {
        frame.size.height = self.maxTextViewHeight;
    }
    else
    {
        frame.size.height = contentSize.height;
    }
    self.noteTextView.frame = frame;
}

- (void) keyboardFrameChanged:(NSNotification *)notification
{
    NSDictionary* dict = notification.userInfo;
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.lastKeyboardHeight = keyboardFrame.size.height;
    
    [self relayoutToolBar];
    [self resetMaxTextViewHeight];
    
    CGRect frame = self.noteTextView.frame;
    if (frame.size.height > self.maxTextViewHeight)
    {
        frame.size.height = self.maxTextViewHeight;
        self.noteTextView.frame = frame;
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.noteTextView)
    {
        if ([keyPath isEqualToString:@"contentSize"])
        {
            CGRect frame = self.noteTextView.frame;
            CGSize contentSize = self.noteTextView.contentSize;
            if (contentSize.height > self.noteTextView.frame.size.height && contentSize.height < self.maxTextViewHeight)
            {
                frame.size.height = contentSize.height;
                self.noteTextView.frame = frame;
            }
            else if (contentSize.height < frame.size.height)
            {
                frame.size.height = contentSize.height;
                self.noteTextView.frame = frame;
            }
            else // contentSize.height > self.maxTextViewHeight
            {
                
                frame.size.height = self.maxTextViewHeight;
                self.noteTextView.frame = frame;
                
                //否则最新的一行在输入的时候看不到
                self.noteTextView.contentOffset = CGPointMake(0, self.noteTextView.contentOffset.y + self.noteTextView.font.lineHeight);
            }
        }
    }
}

- (void) configTapGesture
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnView:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    return !CGRectContainsPoint(self.noteTextView.frame, point);
}

- (void) tapOnView:(UIGestureRecognizer *)gesture
{
    [self.noteTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//new text view

- (void)cancelButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)saveButtonClickedForInsert:(id)sender
{
    NSManagedObjectContext* context = [SXNoteLibrary sharedNotesLibrary].managedObjectContext;
    
    HourNoteItem* item = [NSEntityDescription insertNewObjectForEntityForName:[HourNoteItem classNameString] inManagedObjectContext:context];
    item.content = self.noteTextView.text;
    item.creationDate = [NSDate date];
    
    [[SXNoteLibrary sharedNotesLibrary] sync];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)stopButtonClicked:(id)sender
{
    [self.noteTextView resignFirstResponder];
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    
}

@end
