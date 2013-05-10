//
//  KMLoadMoreCell.m
//  OneDay
//
//  Created by Kimimaro on 13-5-10.
//  Copyright (c) 2013年 Kimi Yu. All rights reserved.
//

#import "KMLoadMoreCell.h"


@interface KMLoadMoreCell ()
@property (nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end


@implementation KMLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setLoading:(BOOL)loading
{
    if (self.isLoading != loading) {
        if (loading) {
            [_indicator startAnimating];
        }
        else {
            [_indicator stopAnimating];
        }
    }
}

- (BOOL)isLoading
{
    return _indicator.isAnimating;
}

@end
