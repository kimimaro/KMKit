//
//  KMTableViewCell.h
//  OneDay
//
//  Created by Yu Tianhang on 12-10-29.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMTableViewCellLocationType) {
    KMTableViewCellLocationTypeAlone = 0,
    KMTableViewCellLocationTypeTop,
    KMTableViewCellLocationTypeMiddle,
    KMTableViewCellLocationTypeBottom
};


@interface KMTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) KMTableViewCellLocationType locationType;

- (void)refreshUI;
@end
