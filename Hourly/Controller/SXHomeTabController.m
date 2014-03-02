//
//  SXHomeTabController.m
//  Hourly
//
//  Created by 胡少华 on 14-3-2.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXHomeTabController.h"
#import "SXHourNotesController.h"

@interface SXHomeTabController ()

@end

@implementation SXHomeTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
//        [UIMenuController sharedMenuController]
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UINavigationController* navi = [self.viewControllers objectAtIndex:0];
    SXHourNotesController* todayNotes = [navi.viewControllers objectAtIndex:0];
    todayNotes.dayDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
