//
//  KMReorderableCollectionViewSnakeLayout.m
//  OneDay
//
//  Created by Yu Tianhang on 12-12-2.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KMReorderableCollectionViewSnakeLayout.h"
#import "KMGeometry.h"


@interface KMReorderableCollectionViewSnakeLayout () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UIEdgeInsets triggerScrollEdgeInsets;
@property (nonatomic) UIEdgeInsets triggerReorderEdgeInsets;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) NSLock *scrollLock;
@property (nonatomic, strong) NSLock *reorderLock;
@end

@implementation KMReorderableCollectionViewSnakeLayout

- (void)initialGestureRecognizers
{
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    for (UIGestureRecognizer *tRecognizer in self.collectionView.gestureRecognizers) {
        if ([tRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [tRecognizer requireGestureRecognizerToFail:_longPressGestureRecognizer];
        }
    }
    _longPressGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_longPressGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:_panGestureRecognizer];
    
    self.triggerScrollEdgeInsets = UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0);
    self.triggerReorderEdgeInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    
    self.scrollLock = [[NSLock alloc] init];
    self.reorderLock = [[NSLock alloc] init];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialGestureRecognizers];
}

#pragma mark - private

- (void)heldCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<KMReorderableCollectionViewDelegateSnakeLayout> tDelegate = nil;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMReorderableCollectionViewDelegateSnakeLayout)]) {
        tDelegate = (id<KMReorderableCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
    }
    
    if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:willBeginReorderingItemAtIndexPath:)]) {
        [tDelegate collectionView:self.collectionView layout:self willBeginReorderingItemAtIndexPath:indexPath];
    }
    
    UICollectionViewCell *tCollectionViewCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    tCollectionViewCell.highlighted = YES;
    UIGraphicsBeginImageContextWithOptions(tCollectionViewCell.bounds.size, tCollectionViewCell.opaque, 0.0f);
    [tCollectionViewCell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tHighlightedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    tCollectionViewCell.highlighted = NO;
    UIGraphicsBeginImageContextWithOptions(tCollectionViewCell.bounds.size, tCollectionViewCell.opaque, 0.0f);
    [tCollectionViewCell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tImageView = [[UIImageView alloc] initWithImage:tImage];
    tImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // Not using constraints, lets auto resizing mask be translated automatically...
    
    UIImageView *tHighlightedImageView = [[UIImageView alloc] initWithImage:tHighlightedImage];
    tHighlightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // Not using constraints, lets auto resizing mask be translated automatically...
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(tCollectionViewCell.frame), CGRectGetMinY(tCollectionViewCell.frame), CGRectGetWidth(tImageView.frame), CGRectGetHeight(tImageView.frame))];
    [tView addSubview:tImageView];
    [tView addSubview:tHighlightedImageView];
    
    [self.collectionView addSubview:tView];
    
    self.currentIndexPath = indexPath;
    self.currentView = tView;
    
    tImageView.alpha = 0.0f;
    tHighlightedImageView.alpha = 1.0f;
    
    [UIView
     animateWithDuration:0.3
     animations:^{
         tView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
         tImageView.alpha = 1.0f;
         tHighlightedImageView.alpha = 0.0f;
     }
     completion:^(BOOL finished) {
         [tHighlightedImageView removeFromSuperview];
         
         if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:didBeginReorderingItemAtIndexPath:)]) {
                 [tDelegate collectionView:self.collectionView layout:self didBeginReorderingItemAtIndexPath:_currentIndexPath];
         }
    }];
    
    [self invalidateLayout];
}

- (void)removeCellForHeldItem
{
    id<KMReorderableCollectionViewDelegateSnakeLayout> tDelegate = nil;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMReorderableCollectionViewDelegateSnakeLayout)]) {
        tDelegate = (id<KMReorderableCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
    }
    
    NSIndexPath *tIndexPath = _currentIndexPath;
    
    if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:willEndReorderingItemAtIndexPath:)]) {
        [tDelegate collectionView:self.collectionView layout:self willEndReorderingItemAtIndexPath:_currentIndexPath];
    }
    
    UICollectionViewLayoutAttributes *tLayoutAttributes = [self layoutAttributesForItemAtIndexPath:tIndexPath];
    __weak KMReorderableCollectionViewSnakeLayout *theWeakSelf = self;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         __strong KMReorderableCollectionViewSnakeLayout *theStrongSelf = theWeakSelf;
                         theStrongSelf.currentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         theStrongSelf.currentView.center = tLayoutAttributes.center;
                     }
                     completion:^(BOOL finished) {
                         __strong KMReorderableCollectionViewSnakeLayout *theStrongSelf = theWeakSelf;
                         [theStrongSelf.currentView removeFromSuperview];
                         self.currentView = nil;
                         self.scrollLock = [[NSLock alloc] init];
                         self.reorderLock = [[NSLock alloc] init];
                         [theStrongSelf invalidateLayout];
                         
                         self.currentIndexPath = nil;
                         
                         if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:didEndReorderingItemAtIndexPath:)]) {
                             [tDelegate collectionView:self.collectionView layout:self didEndReorderingItemAtIndexPath:tIndexPath];
                         }
                     }];
}

- (BOOL)triggerScrollIfNecessary
{
    BOOL isTrigger = NO;
    
    CGPoint tOffset = self.collectionView.contentOffset;
    CGPoint tCenter = _currentView.center;
    CGPoint tLocation = KMRelativePoint(CGPointMake(-self.collectionView.contentOffset.x, -self.collectionView.contentOffset.y), _currentView.center);
    
    // only support Horizontal
    if (tLocation.x < (0.0 + _triggerScrollEdgeInsets.left)
        && self.collectionView.contentOffset.x != 0) {
        // scroll left
        tOffset.x -= self.collectionView.bounds.size.width;
        tCenter.x -= self.collectionView.bounds.size.width;
        
        isTrigger = YES;
        
    } else if (tLocation.x > (self.collectionView.bounds.size.width - _triggerScrollEdgeInsets.right)
               && self.collectionView.contentOffset.x != self.collectionView.contentSize.width - self.collectionView.bounds.size.width) {
        // scroll right
        tOffset.x += self.collectionView.bounds.size.width;
        tCenter.x += self.collectionView.bounds.size.width;
        
        isTrigger = YES;
    }
    
    if (isTrigger) {
        if ([_scrollLock tryLock]) {
            [UIView animateWithDuration:0.45 animations:^{
                self.collectionView.contentOffset = tOffset;
                _currentView.center = tCenter;
            } completion:^(BOOL finished) {
                [self performBlock:^{[_scrollLock unlock];} afterDelay:0.1];
            }];
        }
        else {
            isTrigger = NO;
        }
    }
    
    return isTrigger;
}

- (BOOL)triggerReorderIfNecessary
{
    BOOL isTrigger = NO;
    
    UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:_currentIndexPath];
    CGPoint currentViewCenter = _currentView.center;
    CGPoint currentCellCenter = currentCell.center;
    CGRect currentViewFrame = _currentView.frame;
    
    NSIndexPath *fromIndexPath = _currentIndexPath;
    NSIndexPath *toIndexPath = nil;
    
    KMPointRelativeCoordinate relativeCoordinate = KMPointRelativeCoordinateToPoint(currentViewCenter, currentCellCenter);
    switch (relativeCoordinate) {
        
        case KMPointRelativeCoordinateUpperLeft:
        case KMPointRelativeCoordinateEighthOctant:
        case KMPointRelativeCoordinateJustAbove:
        case KMPointRelativeCoordinateFirstOctant:
        {
            CGPoint bottomMiddle = CGPointMake(currentViewCenter.x, CGRectGetMaxY(currentViewFrame));
            NSIndexPath *tIndexPath = [self.collectionView indexPathForItemAtPoint:bottomMiddle];
            
            if (tIndexPath && ![tIndexPath isEqual:_currentIndexPath]) {
                UICollectionViewCell *tCell = [self.collectionView cellForItemAtIndexPath:tIndexPath];
                if (bottomMiddle.y > CGRectGetMinY(tCell.frame) + _triggerReorderEdgeInsets.top) {
                    toIndexPath = tIndexPath;
                    isTrigger = YES;
                }
            }
        }
            break;

        case KMPointRelativeCoordinateUpperRight:
        case KMPointRelativeCoordinateSecondOctant:
        case KMPointRelativeCoordinateJustRight:
        case KMPointRelativeCoordinateThirdOctant:
        {
            CGPoint rightMiddle = CGPointMake(CGRectGetMaxX(currentViewFrame), currentViewCenter.y);
            NSIndexPath *tIndexPath = [self.collectionView indexPathForItemAtPoint:rightMiddle];
            
            if (tIndexPath && ![tIndexPath isEqual:_currentIndexPath]) {
                UICollectionViewCell *tCell = [self.collectionView cellForItemAtIndexPath:tIndexPath];
                if (rightMiddle.x > CGRectGetMinX(tCell.frame) + _triggerReorderEdgeInsets.left) {
                    toIndexPath = tIndexPath;
                    isTrigger = YES;
                }
            }
        }
            break;

        case KMPointRelativeCoordinateLowerRight:
        case KMPointRelativeCoordinateFourthOctant:
        case KMPointRelativeCoordinateJustBelow:
        case KMPointRelativeCoordinateFifthOctant:
        {
            CGPoint topMiddle = CGPointMake(currentViewCenter.x, CGRectGetMinY(currentViewFrame));
            NSIndexPath *tIndexPath = [self.collectionView indexPathForItemAtPoint:topMiddle];
            
            if (tIndexPath && ![tIndexPath isEqual:_currentIndexPath]) {
                UICollectionViewCell *tCell = [self.collectionView cellForItemAtIndexPath:tIndexPath];
                if (topMiddle.y < CGRectGetMaxY(tCell.frame) - _triggerReorderEdgeInsets.bottom) {
                    toIndexPath = tIndexPath;
                    isTrigger = YES;
                }
            }
        }
            break;

        case KMPointRelativeCoordinateLowerLeft:
        case KMPointRelativeCoordinateSixthOctant:
        case KMPointRelativeCoordinateJustLeft:
        case KMPointRelativeCoordinateSeventhOctant:
        {
            CGPoint leftMiddle = CGPointMake(CGRectGetMinX(currentViewFrame), currentViewCenter.y);
            NSIndexPath *tIndexPath = [self.collectionView indexPathForItemAtPoint:leftMiddle];
            
            if (tIndexPath && ![tIndexPath isEqual:_currentIndexPath]) {
                UICollectionViewCell *tCell = [self.collectionView cellForItemAtIndexPath:tIndexPath];
                if (leftMiddle.x < CGRectGetMaxX(tCell.frame) - _triggerReorderEdgeInsets.right) {
                    toIndexPath = tIndexPath;
                    isTrigger = YES;
                }
            }
        }
            break;

        case KMPointRelativeCoordinateSamePoint:
            break;
    }
    
    if (isTrigger) {
        if ([_reorderLock tryLock]) {
            
            id<KMReorderableCollectionViewDelegateSnakeLayout> tDelegate = nil;
            if ([self.collectionView.delegate conformsToProtocol:@protocol(KMReorderableCollectionViewDelegateSnakeLayout)]) {
                tDelegate = (id<KMReorderableCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
            }
            
            if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:shouldMoveCellForItemAtIndexPath:toIndexPath:)]) {
                if (![tDelegate collectionView:self.collectionView layout:self shouldMoveCellForItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath]) {
                    return NO;
                }
            }
            
            self.currentIndexPath = toIndexPath;
            [self.collectionView performBatchUpdates:^{
                if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:willMoveCellForItemAtIndexPath:toIndexPath:)]) {
                    [tDelegate collectionView:self.collectionView layout:self willMoveCellForItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                }
                
                [self.collectionView deleteItemsAtIndexPaths:@[fromIndexPath]];
                [self.collectionView insertItemsAtIndexPaths:@[toIndexPath]];
            } completion:^(BOOL finished) {
                [_reorderLock unlock];
                
                if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:layout:didMoveCellForItemAtIndexPath:toIndexPath:)]) {
                    [tDelegate collectionView:self.collectionView layout:self didMoveCellForItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                }
            }];
        }
        else {
            isTrigger = NO;
        }
    }
    
    return isTrigger;
}

#pragma mark - Actions

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    id<KMReorderableCollectionViewDelegateSnakeLayout> tDelegate = nil;
    if ([self.collectionView.delegate conformsToProtocol:@protocol(KMReorderableCollectionViewDelegateSnakeLayout)]) {
        tDelegate = (id<KMReorderableCollectionViewDelegateSnakeLayout>)self.collectionView.delegate;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *tIndexPath = [self.collectionView indexPathForItemAtPoint:[recognizer locationInView:self.collectionView]];
            if (tDelegate && [tDelegate respondsToSelector:@selector(collectionView:shouldReorderingItemAtIndexPath:)]) {
                if (![tDelegate collectionView:self.collectionView shouldReorderingItemAtIndexPath:tIndexPath]) {
                    return;
                }
            }
            
            [self heldCellForItemAtIndexPath:tIndexPath];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self removeCellForHeldItem];
        }
            break;
        default:
            break;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint tLocation = [recognizer locationInView:self.collectionView];
            _currentView.center = tLocation;
            
            [self triggerScrollIfNecessary];
            [self triggerReorderIfNecessary];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SubclassingHooks

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *tLayoutAttributesList = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *tAttributes in tLayoutAttributesList) {
        if ([tAttributes.indexPath isEqual:_currentIndexPath] && (tAttributes.representedElementCategory == UICollectionElementCategoryCell)) {
            tAttributes.alpha = 0.f;
        }
    }
    return tLayoutAttributesList;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *tAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if ([tAttributes.indexPath isEqual:_currentIndexPath] && (tAttributes.representedElementCategory == UICollectionElementCategoryCell)) {
        tAttributes.alpha = 0.f;
    }
    return tAttributes;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panGestureRecognizer) {
        return (_currentIndexPath != nil);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return (gestureRecognizer == _longPressGestureRecognizer && otherGestureRecognizer == _panGestureRecognizer) ||
           (gestureRecognizer == _panGestureRecognizer && otherGestureRecognizer == _longPressGestureRecognizer);
}

@end
