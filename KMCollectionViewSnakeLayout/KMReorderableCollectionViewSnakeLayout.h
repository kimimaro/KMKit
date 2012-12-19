//
//  KMReorderableCollectionViewSnakeLayout.h
//  OneDay
//
//  Created by Yu Tianhang on 12-12-2.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMCollectionViewSnakeLayout.h"

@protocol KMReorderableCollectionViewDelegateSnakeLayout <KMCollectionViewDelegateSnakeLayout>
@required
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout shouldMoveCellForItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout willMoveCellForItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout didMoveCellForItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@optional
- (BOOL)collectionView:(UICollectionView *)collectionView shouldReorderingItemAtIndexPath:(NSIndexPath *)indexPath; // default YES

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout willBeginReorderingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout didBeginReorderingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout willEndReorderingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout didEndReorderingItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface KMReorderableCollectionViewSnakeLayout : KMCollectionViewSnakeLayout
@end
