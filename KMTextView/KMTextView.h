//
//  KMTextView.h
//  MedAlarm
//
//  Created by Kimi on 12-10-18.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTextView : UITextView

@property (nonatomic) UIImage *background;
@property (nonatomic) NSString *focusImageName;
@property (nonatomic) NSString *unfocusImageName;

@property(nonatomic,copy) NSString *placeholder;          // default is nil. string is gray

- (void)insertString:(NSString *)insertingString;

@end
