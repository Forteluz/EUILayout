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

+ (instancetype)node:(UIView *)view {
    EUINode *one = [[self.class alloc] init];
    one.view = view;
    return one;
}

- (instancetype)init {
    self = [super init];
    if (self) {
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
    }
    return one;
}

- (__kindof EUINode *)configure:(void(^)(__kindof EUINode *))block {
    if (block) {
        block(self);
    }
    return self;
}

#pragma mark -

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

#pragma mark - NSCopying

@end

