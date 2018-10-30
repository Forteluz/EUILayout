//
//  EUILayout.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayout.h"
#import "UIView+EUILayout.h"

@interface EUILayout()
@end

@implementation EUILayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _flexable  = YES;
        _gravity   = EUIGravityVertStart | EUIGravityHorzStart;
        _sizeType  = EUISizeTypeToFill;
        _margin    = EUIEdgeMake(0, 0, 0, 0);
        _padding   = EUIEdgeMake(0, 0, 0, 0);
        _zPosition = EUILayoutZPostionDefault;
        _maxWidth  = NSNotFound;
        _maxHeight = NSNotFound;
        [self setFrame:(CGRect){NSNotFound,NSNotFound,NSNotFound,NSNotFound}];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize one = CGSizeZero;
    if (self.sizeThatFits) {
        one = self.sizeThatFits(size);
    }
    if (self.view && [self.view respondsToSelector:@selector(sizeThatFits:)]) {
        one = [self.view sizeThatFits:size];
    } else {
        NSCAssert(0, @"视图：[%@] 未实现", self.view);
    }
    return one;
}

- (__kindof EUILayout *)configure:(void(^)(__kindof EUILayout *))block {
    if (block) {
        block(self);
    }
    return self;
}

- (CGSize)validSize {
    CGSize size = {NSNotFound, NSNotFound};
    if (!self.isFlexable && self.view) {
        if (EUIValueIsValid(self.view.bounds.size.width)) {
            size.width = self.view.bounds.size.width;
        }
        if (EUIValueIsValid(self.view.bounds.size.height)) {
            size.height = self.view.bounds.size.height;
        }
        return size;
    }
    
    if (EUIValueIsValid(self.size.width)) {
        size.width = self.size.width;
    } else if (EUIValueIsValid(self.cacheFrame.size.width)) {
        size.width = self.cacheFrame.size.width;
    }
    if (EUIValueIsValid(self.size.height)) {
        size.height = self.size.height;
    } else if (EUIValueIsValid(self.cacheFrame.size.height)) {
        size.height = self.cacheFrame.size.height;
    }
    return size;
}

#pragma mark - Properties

- (void)setSize:(CGSize)size {
    self.width = size.width;
    self.height = size.height;
}

- (CGSize)size {
    return (CGSize) {
        self.width, self.height
    };
}

- (void)setOrigin:(CGPoint)origin {
    self.x = origin.x;
    self.y = origin.y;
}

- (CGPoint)origin {
    return (CGPoint) {
        self.x, self.y
    };
}

- (void)setFrame:(CGRect)frame {
    self.size = frame.size;
    self.origin = frame.origin;
    
}

- (CGRect)frame {
    return (CGRect) {
        .origin = self.origin, .size = self.size
    };
}

- (void)setSizeType:(EUISizeType)sizeType {
    if (_sizeType != sizeType) {
        _sizeType  = sizeType;
        [self setCacheFrame:EUIRectUndefine()];
    }
}

- (void)setGravity:(EUIGravity)gravity {
    if (_gravity != gravity) {
        _gravity  = gravity;
        [self setCacheFrame:EUIRectUndefine()];
    }
}


- (void)setMarginTop:(CGFloat)marginTop {
    self.margin.top = marginTop;
}

- (CGFloat)marginTop {
    return self.margin.top;
}

- (void)setMarginBottom:(CGFloat)marginBottom {
    self.margin.bottom = marginBottom;
}

- (CGFloat)marginBottom {
    return self.margin.bottom;
}

- (void)setMarginLeft:(CGFloat)marginLeft {
    self.margin.left = marginLeft;
}

- (CGFloat)marginLeft {
    return self.margin.left;
}

- (void)setMarginRight:(CGFloat)marginRight {
    self.margin.right = marginRight;
}

- (CGFloat)marginRight {
    return self.margin.right;
}

- (void)setPaddingTop:(CGFloat)paddingTop {
    self.padding.top = paddingTop;
}

- (CGFloat)paddingTop {
    return self.padding.top;
}

- (void)setPaddingBottom:(CGFloat)paddingBottom {
    self.padding.bottom = paddingBottom;
}

- (CGFloat)paddingBottom {
    return self.padding.bottom;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    self.padding.left = paddingLeft;
}

- (CGFloat)paddingLeft {
    return self.padding.left;
}

- (void)setPaddingRight:(CGFloat)paddingRight {
    self.padding.right = paddingRight;
}

- (CGFloat)paddingRight {
    return self.padding.right;
}

#pragma mark - NSCopying

#pragma mark -

- (__kindof EUILayout * (^)(void(^)(__kindof EUILayout *)))config {
    return ^ __kindof EUILayout * (void(^block)(__kindof EUILayout *)) {
        if (block) block(self);
        return self;
    };
}

@end

