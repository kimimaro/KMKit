//
//  KMTableView.h
//  MedAlarm
//
//  Created by Kimi on 12-10-18.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KMTableViewCellBackgroundViewTypeHighlight,
    KMTableViewCellBackgroundViewTypeSelected,
    KMTableViewCellBackgroundViewTypeNormal
} KMTableViewCellBackgroundViewType;

@interface KMTableView : UITableView

//@property (nonatomic) NSString *groupedBackgroundSingleCellBackgroundImageName;
//@property (nonatomic) NSString *groupedHighlightedBackgroundSingleCellBackgroundImageName;
//@property (nonatomic) NSString *groupedSelectedBackgroundSingleCellBackgroundImageName;
//@property (nonatomic) NSString *groupedBackgroundTopCellBackgroundImageName;
//@property (nonatomic) NSString *groupedHighlightedBackgroundTopCellBackgroundImageName;
//@property (nonatomic) NSString *groupedSelectedBackgroundTopCellBackgroundImageName;
//@property (nonatomic) NSString *groupedBackgroundBottomCellBackgroundImageName;
//@property (nonatomic) NSString *groupedHighlightedBackgroundBottomCellBackgroundImageName;
//@property (nonatomic) NSString *groupedSelectedBackgroundBottomCellBackgroundImageName;
//@property (nonatomic) NSString *groupedBackgroundMiddleCellBackgroundImageName;
//@property (nonatomic) NSString *groupedHighlightedBackgroundMiddleCellBackgroundImageName;
//@property (nonatomic) NSString *groupedSelectedBackgroundMiddleCellBackgroundImageName;

- (void)updateBackgroundViewForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath backgroundViewType:(KMTableViewCellBackgroundViewType)type;

@end
