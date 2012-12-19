//
//  KMTextView.m
//  MedAlarm
//
//  Created by Kimi on 12-10-18.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMTextView.h"

@interface KMTextView ()
@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UILabel *placeHolderLabel;
@end

@implementation KMTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    BOOL ret = [super becomeFirstResponder];
    if (ret) {
        if (_focusImageName) {
            UIImage *backgroundImage = [UIImage imageNamed:_focusImageName];
            backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
            self.background = backgroundImage;
        }
    }
    return ret;
}

- (BOOL)resignFirstResponder
{
    BOOL ret = [super resignFirstResponder];
    if (ret) {
        if (_unfocusImageName) {
            UIImage *backgroundImage = [UIImage imageNamed:_unfocusImageName];
            backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
            self.background = backgroundImage;
        }
    }
    return ret;
}

#pragma mark - public

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (!_placeHolderLabel) {
        self.placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:12.f];
        _placeHolderLabel.textColor = [UIColor grayColor];
        _placeHolderLabel.text = _placeholder;
        
        _placeHolderLabel.backgroundColor = [UIColor orangeColor];
        self.backgroundColor = [UIColor blueColor];
        
        CGRect tFrame = self.frame;
        tFrame.size.width -= 20;
        tFrame.size.height -= 10;
        tFrame.origin.x = 10;
        tFrame.origin.y = 5;
        _placeHolderLabel.frame = tFrame;
        
        [self addSubview:_placeHolderLabel];
    }
    else {
        _placeHolderLabel.text = _placeholder;
    }
    
    if (!_placeholder || isEmptyString(_placeholder)) {
        _placeHolderLabel.hidden = YES;
    }
    else {
        _placeHolderLabel.hidden = NO;
        [self bringSubviewToFront:_placeHolderLabel];
    }
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    if (!_backgroundView) {
        self.backgroundView = [[UIImageView alloc] initWithImage:_background];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        CGRect tFrame = self.frame;
        tFrame.origin.x = 0;
        tFrame.origin.y = 0;
        _backgroundView.frame = tFrame;
        [self addSubview:_backgroundView];
    }
    else {
        _backgroundView.image = _background;
    }
    [self sendSubviewToBack:_backgroundView];
}

@end
