//
//  KMGeometry.h
//  OneDay
//
//  Created by Yu Tianhang on 12-12-2.
//  Copyright (c) 2012年 Kimi Yu. All rights reserved.
//

#ifndef OneDay_KMGeometry_h
#define OneDay_KMGeometry_h

/* Return 'point2' relative direction to 'point1' */

CG_EXTERN bool KMPointRelativeCoordinateToPoint(CGPoint point1, CGPoint point2)
CG_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0);

CG_INLINE CGPoint
KMRelativePoint(CGPoint referPoint, CGPoint tPoint)
{
    return CGPointMake(referPoint.x + tPoint.x, referPoint.y + tPoint.y);
}

/* octant 卦限，这里用空间概念卦限来描述象限的两个部分
 * quadrant 象限
 */

typedef NS_ENUM(NSInteger, KMPointRelativeCoordinate) {
    KMPointRelativeCoordinateSamePoint = (1UL << 1), // origin
    
    KMPointRelativeCoordinateJustAbove = (1UL << 2),     // positive y axis
    KMPointRelativeCoordinateJustBelow = (1UL << 3),     // nagative y axis
    KMPointRelativeCoordinateJustLeft = (1UL << 4),      // nagative x axis
    KMPointRelativeCoordinateJustRight = (1UL << 5),     // positive x axis
    
    KMPointRelativeCoordinateUpperLeft = (1UL << 6),
    KMPointRelativeCoordinateUpperRight = (1UL << 7),
    KMPointRelativeCoordinateLowerLeft = (1UL << 8),
    KMPointRelativeCoordinateLowerRight = (1UL << 9),
    
    KMPointRelativeCoordinateFirstOctant = (1UL << 10),
    KMPointRelativeCoordinateSecondOctant = (1UL << 11),
    KMPointRelativeCoordinateThirdOctant = (1UL << 12),
    KMPointRelativeCoordinateFourthOctant = (1UL << 13),
    KMPointRelativeCoordinateFifthOctant = (1UL << 14),
    KMPointRelativeCoordinateSixthOctant = (1UL << 15),
    KMPointRelativeCoordinateSeventhOctant = (1UL << 16),
    KMPointRelativeCoordinateEighthOctant = (1UL << 17)
};

CG_INLINE KMPointRelativeCoordinate
__KMPointRelativeCoordinateToPoint(CGPoint point1, CGPoint point2)  // point2 is the origin
{
    CGPoint diffPoint = CGPointMake(point1.x - point2.x, point1.y - point2.y);
    
    if (diffPoint.x == 0 && diffPoint.y == 0) {
        return KMPointRelativeCoordinateSamePoint;
    }
    else if (diffPoint.x == 0 && diffPoint.y > 0) {
        return KMPointRelativeCoordinateJustAbove;
    }
    else if (diffPoint.x == 0 && diffPoint.y < 0) {
        return KMPointRelativeCoordinateJustBelow;
    }
    else if (diffPoint.x < 0 && diffPoint.y == 0) {
        return KMPointRelativeCoordinateJustLeft;
    }
    else if (diffPoint.x > 0 && diffPoint.y == 0) {
        return KMPointRelativeCoordinateJustRight;
    }
    else if (ABS(diffPoint.x) == ABS(diffPoint.y)) {
        if (diffPoint.x < 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateUpperLeft;
        }
        else if (diffPoint.x > 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateUpperRight;
        }
        else if (diffPoint.x > 0 && diffPoint.y < 0) {
            return KMPointRelativeCoordinateLowerRight;
        }
        else {
            return KMPointRelativeCoordinateLowerLeft;
        }
    }
    else if (ABS(diffPoint.x) > ABS(diffPoint.y)) {
        if (diffPoint.x < 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateSeventhOctant;
        }
        else if (diffPoint.x > 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateSecondOctant;
        }
        else if (diffPoint.x > 0 && diffPoint.y < 0) {
            return KMPointRelativeCoordinateThirdOctant;
        }
        else {
            return KMPointRelativeCoordinateSixthOctant;
        }
    }
    else { // if (ABS(diffPoint.x) < ABS(diffPoint.y))
        if (diffPoint.x < 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateEighthOctant;
        }
        else if (diffPoint.x > 0 && diffPoint.y > 0) {
            return KMPointRelativeCoordinateFirstOctant;
        }
        else if (diffPoint.x > 0 && diffPoint.y < 0) {
            return KMPointRelativeCoordinateFourthOctant;
        }
        else {
            return KMPointRelativeCoordinateFifthOctant;
        }
    }
}
#define KMPointRelativeCoordinateToPoint __KMPointRelativeCoordinateToPoint

#endif
