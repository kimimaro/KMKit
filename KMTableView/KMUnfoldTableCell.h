//
//  KMUnfoldTableCell.h
//  OneDay
//
//  Created by Yu Tianhang on 12-10-29.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMTableViewCell.h"

@interface KMUnfoldTableCell : KMTableViewCell {
    BOOL _unfolded;
}
@property (nonatomic, getter = isUnfolded) BOOL unfolded;
- (NSArray *)foldConstraints;
- (NSArray *)unfoldConstraints;
@end
