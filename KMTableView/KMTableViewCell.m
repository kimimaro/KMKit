//
//  KMTableViewCell.m
//  OneDay
//
//  Created by Yu Tianhang on 12-10-29.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMTableViewCell.h"

@implementation KMTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)refreshUI
{
    // could be extended
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBackgroundImageView:(UIImageView *)backgroundImageView
{
    if (_backgroundImageView) {
        [_backgroundImageView removeFromSuperview];
    }
    _backgroundImageView = backgroundImageView;
    
    if (_backgroundImageView) {
        [self addSubview:_backgroundImageView];
        [self sendSubviewToBack:_backgroundImageView];
    }
}
@end
