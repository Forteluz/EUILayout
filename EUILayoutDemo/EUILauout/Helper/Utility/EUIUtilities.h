//
//  EUIUtilities.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/11.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//const CGSize EUIContainerMaxSize = (CGSize){0x100000, 0x100000};

UIKIT_STATIC_INLINE CGFloat EUIValue(CGFloat one) {
    return (one == NSNotFound) ? 0 : one;
}

UIKIT_STATIC_INLINE CGFloat EUIValid(CGFloat one) {
    return one != NSNotFound;
}

CGFloat EUIScreenScale(void);

static inline CGPoint CGPointPixelCeil(CGPoint point) {
    CGFloat scale = EUIScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

NS_ASSUME_NONNULL_END
