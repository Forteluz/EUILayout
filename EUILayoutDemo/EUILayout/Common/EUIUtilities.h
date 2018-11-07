//
//  EUIUtilities.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/11.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_STATIC_INLINE CGRect EUIRectUndefine() {
    return CGRectMake(NSNotFound, NSNotFound, NSNotFound, NSNotFound);
}

UIKIT_STATIC_INLINE CGSize EUIMaxSize() {
    return CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

UIKIT_STATIC_INLINE CGFloat EUIValueIsUndefine(CGFloat one) {
    return one == NSNotFound;
}

UIKIT_STATIC_INLINE CGFloat EUIValue(CGFloat one) {
    return EUIValueIsUndefine(one) ? 0 : one;
}

UIKIT_STATIC_INLINE CGFloat EUIValueIsValid(CGFloat one) {
    return !EUIValueIsUndefine(one) && one > 0;
}

UIKIT_STATIC_INLINE CGFloat EUIRectIsValid(CGRect one) {
    return !(EUIValueIsUndefine(one.origin.x) || EUIValueIsUndefine(one.origin.y) ||
             !EUIValueIsValid(one.size.width) || !EUIValueIsValid(one.size.height));
}

UIKIT_STATIC_INLINE int EUIRandom(int from, int to) {
    return (int)(from + (arc4random() % (to - from + 1)));
}

CGFloat EUIScreenScale(void);

UIKIT_STATIC_INLINE CGPoint CGPointPixelCeil(CGPoint point) {
    CGFloat scale = EUIScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

UIKIT_STATIC_INLINE CGFloat CGFloatPixelRound(CGFloat value) {
    CGFloat scale = EUIScreenScale();
    return round(value * scale) / scale;
}

NS_ASSUME_NONNULL_END
