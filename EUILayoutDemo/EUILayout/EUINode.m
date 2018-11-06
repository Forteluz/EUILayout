//
//  EUINode.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUINode.h"
#import "UIView+EUILayout.h"

@interface EUINode()
@end

@implementation EUINode

- (instancetype)init {
    self = [super init];
    if (self) {
        _flexable  = YES;
        _gravity   = EUIGravityNone;
        _sizeType  = EUISizeTypeNone;
        _margin    = EUIEdgeMake(NSNotFound, NSNotFound, NSNotFound, NSNotFound);
        _padding   = EUIEdgeMake(NSNotFound, NSNotFound, NSNotFound, NSNotFound);
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

- (__kindof EUINode *)configure:(void(^)(__kindof EUINode *))block {
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

#define EUIPropertyAssign(_P_) \
if (_##_P_ != _P_) { _##_P_ = _P_; [self setCacheFrame:EUIRectUndefine()]; }

- (void)setX:(CGFloat)x {
    EUIPropertyAssign(x);
}

- (void)setY:(CGFloat)y {
    EUIPropertyAssign(y);
}

- (void)setWidth:(CGFloat)width {
    EUIPropertyAssign(width);
}

- (void)setHeight:(CGFloat)height {
    EUIPropertyAssign(height);
}
- (void)setMaxWidth:(CGFloat)maxWidth {
    EUIPropertyAssign(maxWidth)
}

- (void)setMinWidth:(CGFloat)minWidth {
    EUIPropertyAssign(minWidth)
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    EUIPropertyAssign(maxHeight)
}

- (void)setMinHeight:(CGFloat)minHeight {
    EUIPropertyAssign(minHeight)
}

- (void)setSizeType:(EUISizeType)sizeType {
    EUIPropertyAssign(sizeType)
}

- (void)setGravity:(EUIGravity)gravity {
    EUIPropertyAssign(gravity)
}

- (void)setSize:(CGSize)size {
    self.width = size.width;
    self.height = size.height;
}

- (CGSize)size {
    return (CGSize) { self.width, self.height };
}

- (void)setOrigin:(CGPoint)origin {
    self.x = origin.x;
    self.y = origin.y;
}

- (CGPoint)origin {
    return (CGPoint) { self.x, self.y };
}

- (void)setFrame:(CGRect)frame {
    self.size = frame.size;
    self.origin = frame.origin;
}

- (CGRect)frame {
    return (CGRect) { .origin = self.origin, .size = self.size };
}

- (BOOL)isTemplet {
    return [self isKindOfClass:EUITemplet.class];
}

#pragma mark - Layout Property Capacityas

#define EUICopyValueIfNeeded(_VAL_) \
if (EUIValueIsUndefine(self._VAL_) && !EUIValueIsUndefine(layout._VAL_)) { self._VAL_ = layout._VAL_; }

- (void)inheritBy:(EUINode *)layout {
    EUICopyValueIfNeeded(x)
    EUICopyValueIfNeeded(y)
    EUICopyValueIfNeeded(width)
    EUICopyValueIfNeeded(height)
    EUICopyValueIfNeeded(maxWidth)
    EUICopyValueIfNeeded(minWidth)
    EUICopyValueIfNeeded(maxHeight)
    EUICopyValueIfNeeded(minHeight)
    EUICopyValueIfNeeded(padding.left)
    EUICopyValueIfNeeded(padding.top)
    EUICopyValueIfNeeded(padding.right)
    EUICopyValueIfNeeded(padding.bottom)
    EUICopyValueIfNeeded(margin.left)
    EUICopyValueIfNeeded(margin.top)
    EUICopyValueIfNeeded(margin.right)
    EUICopyValueIfNeeded(margin.bottom)

    if (layout.sizeType != EUISizeTypeNone) {
        self.sizeType = layout.sizeType;
    }
    if (layout.gravity != EUIGravityNone) {
        self.gravity = layout.gravity;
    }
    
    self.templet = layout.templet;
}

#pragma mark - NSCopying

#pragma mark -

- (__kindof EUINode * (^)(void(^)(__kindof EUINode *)))config {
    return ^ __kindof EUINode * (void(^block)(__kindof EUINode *)) {
        if (block) block(self);
        return self;
    };
}

@end

