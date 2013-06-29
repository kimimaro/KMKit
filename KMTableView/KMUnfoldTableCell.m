//
//  KMUnfoldTableCell.m
//  OneDay
//
//  Created by Yu Tianhang on 12-10-29.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMUnfoldTableCell.h"

@implementation KMUnfoldTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - setter&getter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUnfolded:(BOOL)unfolded
{
    _unfolded = unfolded;
    
    if (_unfolded) {
        [self removeConstraints:[self constraints]];
        [self addConstraints:[self unfoldConstraints]];
    }
    else {
        [self removeConstraints:[self constraints]];
        [self addConstraints:[self foldConstraints]];
    }
}

#pragma mark - extended

- (NSArray *)foldConstraints
{
    return @[];
}

- (NSArray *)unfoldConstraints
{
    return @[];
}

@end
