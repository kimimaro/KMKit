//
//  KMTableView.m
//  MedAlarm
//
//  Created by Kimi on 12-10-18.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMTableView.h"
#import "KMTableViewCell.h"
#import "KMCheckboxTableCell.h"


@interface KMTableView ()
//@property (nonatomic, retain) UIImage *groupedBackgroundSingleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedHighlightBackgroundSingleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedSelectedBackgroundSingleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedBackgroundTopCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedHighlightBackgroundTopCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedSelectedBackgroundTopCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedBackgroundMiddleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedHighlightBackgroundMiddleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedSelectedBackgroundMiddleCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedBackgroundBottomCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedHighlightBackgroundBottomCellBackgroundImage;
//@property (nonatomic, retain) UIImage *groupedSelectedBackgroundBottomCellBackgroundImage;
@end


@implementation KMTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // default image names
//        self.groupedBackgroundSingleCellBackgroundImageName = @"cell_normal_alone";
//        self.groupedHighlightedBackgroundSingleCellBackgroundImageName = @"cell_tinted_alone";
//        self.groupedSelectedBackgroundSingleCellBackgroundImageName = @"cell_selected_alone";
//        self.groupedBackgroundTopCellBackgroundImageName = @"cell_normal_top";
//        self.groupedHighlightedBackgroundTopCellBackgroundImageName = @"cell_tinted_top";
//        self.groupedSelectedBackgroundTopCellBackgroundImageName = @"cell_selected_top";
//        self.groupedBackgroundBottomCellBackgroundImageName = @"cell_normal_bottom";
//        self.groupedHighlightedBackgroundBottomCellBackgroundImageName = @"cell_tinted_bottom";
//        self.groupedSelectedBackgroundBottomCellBackgroundImageName = @"cell_selected_bottom";
//        self.groupedBackgroundMiddleCellBackgroundImageName = @"cell_normal_middle";
//        self.groupedHighlightedBackgroundMiddleCellBackgroundImageName = @"cell_tinted_middle";
//        self.groupedSelectedBackgroundMiddleCellBackgroundImageName = @"cell_selected_middle";
    }
    return self;
}

#pragma mark - UI

- (void)updateBackgroundViewForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath backgroundViewType:(KMTableViewCellBackgroundViewType)type
{
    return;
    
//    if (!_groupedBackgroundSingleCellBackgroundImage) {
//        
//        UIImage *BackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedBackgroundSingleCellBackgroundImageName];
//        BackgroundSingleBackgroundImage = [BackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:BackgroundSingleBackgroundImage.size.width/2 topCapHeight:BackgroundSingleBackgroundImage.size.height/2];
//        UIImage *HighlightedBackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundSingleCellBackgroundImageName];
//        HighlightedBackgroundSingleBackgroundImage = [HighlightedBackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundSingleBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundSingleBackgroundImage.size.height/2];
//        UIImage *SelectedBackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundSingleCellBackgroundImageName];
//        SelectedBackgroundSingleBackgroundImage = [SelectedBackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundSingleBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundSingleBackgroundImage.size.height/2];
//        self.groupedBackgroundSingleCellBackgroundImage = BackgroundSingleBackgroundImage;
//        self.groupedHighlightBackgroundSingleCellBackgroundImage = HighlightedBackgroundSingleBackgroundImage;
//        self.groupedSelectedBackgroundSingleCellBackgroundImage = SelectedBackgroundSingleBackgroundImage;
//        
//        UIImage *BackgroundTopBackgroundImage = [UIImage imageNamed:_groupedBackgroundTopCellBackgroundImageName];
//        BackgroundTopBackgroundImage = [BackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:BackgroundTopBackgroundImage.size.width/2 topCapHeight:BackgroundTopBackgroundImage.size.height/2];
//        UIImage *HighlightedBackgroundTopBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundTopCellBackgroundImageName];
//        HighlightedBackgroundTopBackgroundImage = [HighlightedBackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundTopBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundTopBackgroundImage.size.height/2];
//        UIImage *SelectedBackgroundTopBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundTopCellBackgroundImageName];
//        SelectedBackgroundTopBackgroundImage = [SelectedBackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundTopBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundTopBackgroundImage.size.height/2];
//        self.groupedBackgroundTopCellBackgroundImage = BackgroundTopBackgroundImage;
//        self.groupedHighlightBackgroundTopCellBackgroundImage = HighlightedBackgroundTopBackgroundImage;
//        self.groupedSelectedBackgroundTopCellBackgroundImage = SelectedBackgroundTopBackgroundImage;
//        
//        UIImage *BackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedBackgroundBottomCellBackgroundImageName];
//        BackgroundBottomBackgroundImage = [BackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:BackgroundBottomBackgroundImage.size.width/2 topCapHeight:BackgroundBottomBackgroundImage.size.height/2];
//        UIImage *HighlightedBackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundBottomCellBackgroundImageName];
//        HighlightedBackgroundBottomBackgroundImage = [HighlightedBackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundBottomBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundBottomBackgroundImage.size.height/2];
//        UIImage *SelectedBackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundBottomCellBackgroundImageName];
//        SelectedBackgroundBottomBackgroundImage = [SelectedBackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundBottomBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundBottomBackgroundImage.size.height/2];
//        self.groupedBackgroundBottomCellBackgroundImage = BackgroundBottomBackgroundImage;
//        self.groupedHighlightBackgroundBottomCellBackgroundImage = HighlightedBackgroundBottomBackgroundImage;
//        self.groupedSelectedBackgroundBottomCellBackgroundImage = SelectedBackgroundBottomBackgroundImage;
//        
//        UIImage *BackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedBackgroundMiddleCellBackgroundImageName];
//        BackgroundMiddleBackgroundImage = [BackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:BackgroundMiddleBackgroundImage.size.width/2 topCapHeight:BackgroundMiddleBackgroundImage.size.height/2];
//        UIImage *HighlightedBackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundMiddleCellBackgroundImageName];
//        HighlightedBackgroundMiddleBackgroundImage = [HighlightedBackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundMiddleBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundMiddleBackgroundImage.size.height/2];
//        UIImage *SelectedBackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundMiddleCellBackgroundImageName];
//        SelectedBackgroundMiddleBackgroundImage = [SelectedBackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundMiddleBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundMiddleBackgroundImage.size.height/2];
//        self.groupedBackgroundMiddleCellBackgroundImage = BackgroundMiddleBackgroundImage;
//        self.groupedHighlightBackgroundMiddleCellBackgroundImage = HighlightedBackgroundMiddleBackgroundImage;
//        self.groupedSelectedBackgroundMiddleCellBackgroundImage = SelectedBackgroundMiddleBackgroundImage;
//    }
//    
//    BOOL groupOffsetY = 0.0;
//    CGFloat groupHeight = 0.0;
//    
//    KMTableViewCell *tCell = (KMTableViewCell *)cell;
//    UIImageView *backgroundImageView = nil;
//    if (tCell) {
//        if ([self numberOfRowsInSection:indexPath.section] == 1) {
//            tCell.locationType = KMTableViewCellLocationTypeAlone;
//            groupOffsetY = -10.f;
//            groupHeight = 20.f;
//            switch (type) {
//                case KMTableViewCellBackgroundViewTypeHighlight:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedHighlightBackgroundSingleCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeSelected:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedSelectedBackgroundSingleCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeNormal:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedBackgroundSingleCellBackgroundImage];
//                    break;
//            }
//        } else if (indexPath.row == 0) {
//            tCell.locationType = KMTableViewCellLocationTypeTop;
//            groupOffsetY = -10.f;
//            groupHeight = 10.f;
//            switch (type) {
//                case KMTableViewCellBackgroundViewTypeHighlight:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedHighlightBackgroundTopCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeSelected:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedSelectedBackgroundTopCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeNormal:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedBackgroundTopCellBackgroundImage];
//                    break;
//            }
//        } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
//            tCell.locationType = KMTableViewCellLocationTypeBottom;
//            groupHeight = 10.f;
//            switch (type) {
//                case KMTableViewCellBackgroundViewTypeHighlight:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedHighlightBackgroundBottomCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeSelected:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedSelectedBackgroundBottomCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeNormal:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedBackgroundBottomCellBackgroundImage];
//                    break;
//            }
//        } else {
//            tCell.locationType = KMTableViewCellLocationTypeMiddle;
//            switch (type) {
//                case KMTableViewCellBackgroundViewTypeHighlight:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedHighlightBackgroundMiddleCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeSelected:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedSelectedBackgroundMiddleCellBackgroundImage];
//                    break;
//                case KMTableViewCellBackgroundViewTypeNormal:
//                    backgroundImageView = [[UIImageView alloc] initWithImage:_groupedBackgroundMiddleCellBackgroundImage];
//                    break;
//            }
//        }
//        
//        tCell.backgroundView = nil;
//        tCell.backgroundColor = [UIColor clearColor];
//        
//        if ([tCell isKindOfClass:[KMTableViewCell class]]) {
//            backgroundImageView.frame = CGRectMake(0, groupOffsetY, SSWidth(tCell), SSHeight(tCell) + groupHeight);
//            ((KMTableViewCell*)tCell).backgroundImageView = backgroundImageView;
//            
//            CGRect tFrame = tCell.contentView.frame;
//            tFrame.origin.x -= 10.f;
//            tFrame.size.width -= 20.f;
//            tCell.contentView.frame = tFrame;
//        }
//        else {
//            tCell.backgroundView = backgroundImageView;
//        }
//    }
}

@end
