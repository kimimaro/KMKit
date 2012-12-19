//
//  KMTextField.m
//  MedAlarm
//
//  Created by Kimi on 12-10-18.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMTextField.h"

@implementation KMTextField

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
        UIImage *backgroundImage = [UIImage imageNamed:_focusImageName];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
        self.background = backgroundImage;
    }
    return ret;
}

- (BOOL)resignFirstResponder
{
    BOOL ret = [super resignFirstResponder];
    if (ret) {
        UIImage *backgroundImage = [UIImage imageNamed:_unfocusImageName];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
        self.background = backgroundImage;
    }
    return ret;
}

@end
