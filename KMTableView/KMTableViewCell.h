//
//  KMTableViewCell.h
//  OneDay
//
//  Created by Yu Tianhang on 12-10-29.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMTableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
- (void)refreshUI;
@end
