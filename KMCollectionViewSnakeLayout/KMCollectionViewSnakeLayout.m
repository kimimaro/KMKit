//
//  KMCollectionViewSnakeLayout.m
//  OneDay
//
//  Created by Yu Tianhang on 12-12-1.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import "KMCollectionViewSnakeLayout.h"

@interface KMCollectionViewSnakeLayout ()

@property (nonatomic, readwrite) KMCollectionViewScrollDirection scrollDirection;
@property (nonatomic, strong) NSArray *attributesList;

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;
- (CGSize)sizeForSectionAtIndex:(NSInteger)section;
@end

@implementation KMCollectionViewSnakeLayout

- (void)initialDefaultValues
{
    self.minimumLineSpacing = 10.0;
    self.minimumInteritemSpacing = 10.0;
    self.itemSize = CGSizeMake(50.0, 50.0);
    self.scrollDirection = KMCollectionViewScrollDirectionHorizontal;
    self.sectionSize = self.collectionView.bounds.size;
    
    self.sectionInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialDefaultValues];
}

#pragma mark - SubclassingHooks

- (void)prepareLayout
{
    [self initialAttributesList];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *ret = [NSMutableArray array];
    for (NSArray *subAttributesList in _attributesList) {
        for (UICollectionViewLayoutAttributes *tmpAttributes in subAttributesList) {
            if (CGRectIntersectsRect(rect, tmpAttributes.frame)) {
                [ret addObject:tmpAttributes];
            }
        }
    }
    return [ret copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_attributesList objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
}

- (CGSize)collectionViewContentSize
{
    CGSize ret = CGSizeZero;
    
    switch (_scrollDirection) {
        case KMCollectionViewScrollDirectionHorizontal:
        {
            for (int i=0; i < [self.collectionView numberOfSections]; i++) {
                CGSize sectionSize = [self sizeForSectionAtIndex:i];
                ret.width += sectionSize.width;
                ret.height = MAX(ret.height, sectionSize.height);
            }
        }
            break;
    }
    
    if (self.collectionView.pagingEnabled) {
        ret.width = ceilf(ret.width/self.collectionView.bounds.size.width) * self.collectionView.bounds.size.width;
    }
    return ret;
}

#pragma mark - calculate item frame

- (void)initialAttributesList
{
    NSMutableArray *tmpAttributesList = [NSMutableArray array];
    CGPoint sectionOffset = CGPointMake(0.0, 0.0);
    
    for (int section=0; section < [self.collectionView numberOfSections]; section++) {
        
        CGSize sectionSize = [self sizeForSectionAtIndex:section];
        UIEdgeInsets sectionInsets = [self insetForSectionAtIndex:section];
        
        // store values
        CGFloat lineSpacing = [self minimumLineSpacingForSectionAtIndex:section];
        CGFloat totalItemsWidth = sectionInsets.left + sectionInsets.right;
        CGFloat lineMaxHeight = 0.0;
        
        int itemCount = [self.collectionView numberOfItemsInSection:section];
        
        NSMutableArray *subAttributesList = [NSMutableArray arrayWithCapacity:itemCount];
        CGFloat originX = sectionOffset.x + sectionInsets.left;
        CGFloat originY = sectionOffset.y + sectionInsets.top;
        
        for (int item=0; item < itemCount; item++) {
            NSIndexPath *tIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *tmpAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:tIndexPath];
            CGSize itemSize = [self sizeForItemAtIndexPath:tIndexPath];
            tmpAttributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
            
            [subAttributesList addObject:tmpAttributes];
            
            CGFloat interitemSpacing = [self interitemSpacingForItemAtIndexPath:tIndexPath];
            if (totalItemsWidth + itemSize.width < sectionSize.width) {
                totalItemsWidth += itemSize.width + interitemSpacing;
                originX += itemSize.width + interitemSpacing;
                lineMaxHeight = MAX(lineMaxHeight, itemSize.height);
            }
            else {
                originY += lineMaxHeight + lineSpacing;
                
                // restore default value
//                interitemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
                totalItemsWidth = sectionInsets.left + sectionInsets.right + itemSize.width;
                lineMaxHeight = itemSize.height;
                originX = sectionOffset.x + sectionInsets.left;
            }
        }
        
        [tmpAttributesList addObject:subAttributesList];
        sectionOffset = CGPointMake(sectionOffset.x + sectionSize.width, 0.0);
    }
    self.attributesList = [tmpAttributesList copy];
}

- (CGFloat)interitemSpacingForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    CGSize sectionSize = [self sizeForSectionAtIndex:section];
    UIEdgeInsets sectionInsets = [self insetForSectionAtIndex:section];
    
    CGFloat interitemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
    CGFloat totalItemsWidth = sectionInsets.left + sectionInsets.right;
    NSInteger numberOfItemInLine = 0;
    
    CGFloat ret = interitemSpacing;
    BOOL inThisLine = NO;
    for (int i=0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
        CGSize itemSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
        if (totalItemsWidth + itemSize.width <= sectionSize.width) {
            totalItemsWidth += itemSize.width + interitemSpacing;
            numberOfItemInLine ++;
        }
        else {
            if (inThisLine) {
                totalItemsWidth -= (numberOfItemInLine - 1) * interitemSpacing;
                ret = (sectionSize.width - totalItemsWidth) / (numberOfItemInLine - 1);
                break;
            }
            
            // restore default value
            interitemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
            totalItemsWidth = sectionInsets.left + sectionInsets.right + itemSize.width;
            numberOfItemInLine = 1;
        }
        
        inThisLine = (item == i);
    }
    return ret;
}

- (CGFloat)lineSpacingForSectionAtIndex:(NSInteger)section  // never called in Horizontal Direction
{
    CGSize sectionSize = [self sizeForSectionAtIndex:section];
    UIEdgeInsets sectionInsets = [self insetForSectionAtIndex:section];
    
    CGFloat lineSpacing = [self minimumLineSpacingForSectionAtIndex:section];
    CGFloat interitemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
    
    CGFloat totalItemsWidth = sectionInsets.left + sectionInsets.right;
    CGFloat totalItemsHeight = sectionInsets.top + sectionInsets.bottom;
    NSInteger numberOfLines = 1;
    
    CGFloat lineMaxHeight = 0.0;
    
    for (int i=0; i < [self.collectionView numberOfItemsInSection:section]; i++) {
        CGSize itemSize = [self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]];
        if (totalItemsWidth + itemSize.width <= sectionSize.width) {
            totalItemsWidth += itemSize.width + interitemSpacing;
            lineMaxHeight = MAX(lineMaxHeight, itemSize.height);
        }
        else {
            numberOfLines ++;
            totalItemsHeight += lineMaxHeight + lineSpacing;
            
            // restore default value
            interitemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
            totalItemsWidth = sectionInsets.left + sectionInsets.right + itemSize.width;
            lineMaxHeight = itemSize.height;
        }
    }
    
    numberOfLines ++;
    totalItemsHeight += lineMaxHeight + lineSpacing;
    totalItemsHeight -= lineSpacing * (numberOfLines - 1);
    
    CGFloat ret = (sectionSize.height - totalItemsHeight) / (numberOfLines - 1);
    return ret;
}

#pragma mark - setter&getter

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat ret = _minimumLineSpacing;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMCollectionViewDelegateSnakeLayout)]) {
        id<KMCollectionViewDelegateSnakeLayout> tDelegate = (id<KMCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
        if ([tDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            ret = [tDelegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
        }
    }
    return ret;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat ret = _minimumInteritemSpacing;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMCollectionViewDelegateSnakeLayout)]) {
        id<KMCollectionViewDelegateSnakeLayout> tDelegate = (id<KMCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
        if ([tDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            ret = [tDelegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
        }
    }
    return ret;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize ret = _itemSize;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMCollectionViewDelegateSnakeLayout)]) {
        id<KMCollectionViewDelegateSnakeLayout> tDelegate = (id<KMCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
        if ([tDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
            ret = [tDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        }
    }
    return ret;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets ret = _sectionInsets;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMCollectionViewDelegateSnakeLayout)]) {
        id<KMCollectionViewDelegateSnakeLayout> tDelegate = (id<KMCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
        if ([tDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            ret = [tDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
        }
    }
    return ret;
}

- (CGSize)sizeForSectionAtIndex:(NSInteger)section
{
    CGSize ret = _sectionSize;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMCollectionViewDelegateSnakeLayout)]) {
        id<KMCollectionViewDelegateSnakeLayout> tDelegate = (id<KMCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
        if ([tDelegate respondsToSelector:@selector(collectionView:layout:sizeForSectionAtIndex:)]) {
            ret = [tDelegate collectionView:self.collectionView layout:self sizeForSectionAtIndex:section];
        }
    }
    return ret;
}
@end

