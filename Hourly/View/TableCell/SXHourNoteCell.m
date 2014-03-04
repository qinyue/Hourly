//
//  SXHourNoteCell.m
//  Hourly
//
//  Created by 胡少华 on 14-3-4.
//  Copyright (c) 2014年 shangxia. All rights reserved.
//

#import "SXHourNoteCell.h"

@implementation SXHourNoteCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}

- (id) initWithReuseId:(NSString *)reuseId
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    if (self)
    {
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect titleFrame = self.textLabel.frame;
    titleFrame.origin.y = 6;
    titleFrame.origin.x = 10;
    titleFrame.size.height = 20;
    self.textLabel.frame = titleFrame;
    
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.x = 10;
    detailFrame.origin.y = 6 + 20 + 4;
    detailFrame.size = self.detailSize;
    self.detailTextLabel.frame = detailFrame;
    
}

@end
