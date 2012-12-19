//
//  KMCollectionViewSnakeLayout.h
//  OneDay
//
//  Created by Yu Tianhang on 12-12-1.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <UIKit/UICollectionViewLayout.h>
#import <UIKit/UICollectionView.h>
#import <UIKit/UIKitDefines.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KMCollectionViewScrollDirection) {
    KMCollectionViewScrollDirectionHorizontal
};

@protocol KMCollectionViewDelegateSnakeLayout <UICollectionViewDelegate>
@optional

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForSectionAtIndex:(NSInteger)section;
@end

NS_CLASS_AVAILABLE_IOS(6_0) @interface KMCollectionViewSnakeLayout : UICollectionViewLayout

@property (nonatomic) CGFloat minimumLineSpacing;       // For a horizontal scrolling grid, this value represents the minimum spacing between successive rows, default is 10.0
@property (nonatomic) CGFloat minimumInteritemSpacing;  // For a horizontal scrolling grid, this value represents the minimum spacing between items in the same row, default is 10.0
@property (nonatomic) CGSize itemSize;  // default is (50.0, 50.0)
@property (nonatomic, readonly) KMCollectionViewScrollDirection scrollDirection; // only support KMCollectionViewScrollDirectionHorizontal

@property (nonatomic) UIEdgeInsets sectionInsets;    // reflect the spacing at the outer edges of the section
@property (nonatomic) CGSize sectionSize;   // default is (320.0, 568.0)
@end
