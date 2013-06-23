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

@implementation KMTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // default image names
        self.groupedBackgroundSingleCellBackgroundImageName = @"cell_normal_alone";
        self.groupedHighlightedBackgroundSingleCellBackgroundImageName = @"cell_tinted_alone";
        self.groupedSelectedBackgroundSingleCellBackgroundImageName = @"cell_selected_alone";
        self.groupedBackgroundTopCellBackgroundImageName = @"cell_normal_top";
        self.groupedHighlightedBackgroundTopCellBackgroundImageName = @"cell_tinted_top";
        self.groupedSelectedBackgroundTopCellBackgroundImageName = @"cell_selected_top";
        self.groupedBackgroundBottomCellBackgroundImageName = @"cell_normal_bottom";
        self.groupedHighlightedBackgroundBottomCellBackgroundImageName = @"cell_tinted_bottom";
        self.groupedSelectedBackgroundBottomCellBackgroundImageName = @"cell_selected_bottom";
        self.groupedBackgroundMiddleCellBackgroundImageName = @"cell_normal_middle";
        self.groupedHighlightedBackgroundMiddleCellBackgroundImageName = @"cell_tinted_middle";
        self.groupedSelectedBackgroundMiddleCellBackgroundImageName = @"cell_selected_middle";
    }
    return self;
}

#pragma mark - UI

- (void)updateBackgroundViewForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath backgroundViewType:(KMTableViewCellBackgroundViewType)type
{
    UIImageView *backgroundImageView = nil;
    UIImage *BackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedBackgroundSingleCellBackgroundImageName];
    BackgroundSingleBackgroundImage = [BackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:BackgroundSingleBackgroundImage.size.width/2 topCapHeight:BackgroundSingleBackgroundImage.size.height/2];
    UIImage *HighlightedBackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundSingleCellBackgroundImageName];
    HighlightedBackgroundSingleBackgroundImage = [HighlightedBackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundSingleBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundSingleBackgroundImage.size.height/2];
    UIImage *SelectedBackgroundSingleBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundSingleCellBackgroundImageName];
    SelectedBackgroundSingleBackgroundImage = [SelectedBackgroundSingleBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundSingleBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundSingleBackgroundImage.size.height/2];
    
    UIImage *BackgroundTopBackgroundImage = [UIImage imageNamed:_groupedBackgroundTopCellBackgroundImageName];
    BackgroundTopBackgroundImage = [BackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:BackgroundTopBackgroundImage.size.width/2 topCapHeight:BackgroundTopBackgroundImage.size.height/2];
    UIImage *HighlightedBackgroundTopBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundTopCellBackgroundImageName];
    HighlightedBackgroundTopBackgroundImage = [HighlightedBackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundTopBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundTopBackgroundImage.size.height/2];
    UIImage *SelectedBackgroundTopBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundTopCellBackgroundImageName];
    SelectedBackgroundTopBackgroundImage = [SelectedBackgroundTopBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundTopBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundTopBackgroundImage.size.height/2];
    
    UIImage *BackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedBackgroundBottomCellBackgroundImageName];
    BackgroundBottomBackgroundImage = [BackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:BackgroundBottomBackgroundImage.size.width/2 topCapHeight:BackgroundBottomBackgroundImage.size.height/2];
    UIImage *HighlightedBackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundBottomCellBackgroundImageName];
    HighlightedBackgroundBottomBackgroundImage = [HighlightedBackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundBottomBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundBottomBackgroundImage.size.height/2];
    UIImage *SelectedBackgroundBottomBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundBottomCellBackgroundImageName];
    SelectedBackgroundBottomBackgroundImage = [SelectedBackgroundBottomBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundBottomBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundBottomBackgroundImage.size.height/2];
    
    UIImage *BackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedBackgroundMiddleCellBackgroundImageName];
    BackgroundMiddleBackgroundImage = [BackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:BackgroundMiddleBackgroundImage.size.width/2 topCapHeight:BackgroundMiddleBackgroundImage.size.height/2];
    UIImage *HighlightedBackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedHighlightedBackgroundMiddleCellBackgroundImageName];
    HighlightedBackgroundMiddleBackgroundImage = [HighlightedBackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:HighlightedBackgroundMiddleBackgroundImage.size.width/2 topCapHeight:HighlightedBackgroundMiddleBackgroundImage.size.height/2];
    UIImage *SelectedBackgroundMiddleBackgroundImage = [UIImage imageNamed:_groupedSelectedBackgroundMiddleCellBackgroundImageName];
    SelectedBackgroundMiddleBackgroundImage = [SelectedBackgroundMiddleBackgroundImage stretchableImageWithLeftCapWidth:SelectedBackgroundMiddleBackgroundImage.size.width/2 topCapHeight:SelectedBackgroundMiddleBackgroundImage.size.height/2];
    
    BOOL groupOffsetY = 0.0;
    CGFloat groupHeight = 0.0;
    
    KMTableViewCell *tCell = (KMTableViewCell *)cell;
    if (tCell) {
        if ([self numberOfRowsInSection:indexPath.section] == 1) {
            tCell.locationType = KMTableViewCellLocationTypeAlone;
            groupOffsetY = -10.f;
            groupHeight = 20.f;
            switch (type) {
                case KMTableViewCellBackgroundViewTypeHighlight:
                    backgroundImageView = [[UIImageView alloc] initWithImage:HighlightedBackgroundSingleBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeSelected:
                    backgroundImageView = [[UIImageView alloc] initWithImage:SelectedBackgroundSingleBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeNormal:
                    backgroundImageView = [[UIImageView alloc] initWithImage:BackgroundSingleBackgroundImage];
                    break;
            }
        } else if (indexPath.row == 0) {
            tCell.locationType = KMTableViewCellLocationTypeTop;
            groupOffsetY = -10.f;
            groupHeight = 10.f;
            switch (type) {
                case KMTableViewCellBackgroundViewTypeHighlight:
                    backgroundImageView = [[UIImageView alloc] initWithImage:HighlightedBackgroundTopBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeSelected:
                    backgroundImageView = [[UIImageView alloc] initWithImage:SelectedBackgroundTopBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeNormal:
                    backgroundImageView = [[UIImageView alloc] initWithImage:BackgroundTopBackgroundImage];
                    break;
            }
        } else if (indexPath.row == [self numberOfRowsInSection:indexPath.section] - 1) {
            tCell.locationType = KMTableViewCellLocationTypeBottom;
            groupHeight = 10.f;
            switch (type) {
                case KMTableViewCellBackgroundViewTypeHighlight:
                    backgroundImageView = [[UIImageView alloc] initWithImage:HighlightedBackgroundBottomBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeSelected:
                    backgroundImageView = [[UIImageView alloc] initWithImage:SelectedBackgroundBottomBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeNormal:
                    backgroundImageView = [[UIImageView alloc] initWithImage:BackgroundBottomBackgroundImage];
                    break;
            }
        } else {
            tCell.locationType = KMTableViewCellLocationTypeMiddle;
            switch (type) {
                case KMTableViewCellBackgroundViewTypeHighlight:
                    backgroundImageView = [[UIImageView alloc] initWithImage:HighlightedBackgroundMiddleBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeSelected:
                    backgroundImageView = [[UIImageView alloc] initWithImage:SelectedBackgroundMiddleBackgroundImage];
                    break;
                case KMTableViewCellBackgroundViewTypeNormal:
                    backgroundImageView = [[UIImageView alloc] initWithImage:BackgroundMiddleBackgroundImage];
                    break;
            }
        }
        
        tCell.backgroundView = nil;
        tCell.backgroundColor = [UIColor clearColor];
        
        if ([tCell isKindOfClass:[KMTableViewCell class]]) {
            backgroundImageView.frame = CGRectMake(0, groupOffsetY, tCell.bounds.size.width, tCell.bounds.size.height + groupHeight);
            ((KMTableViewCell*)tCell).backgroundImageView = backgroundImageView;
        }
        else {
            tCell.backgroundView = backgroundImageView;
        }
    }
}

@end
