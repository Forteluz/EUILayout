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
@synthesize padding = _padding;

+ (instancetype)node:(UIView *)view {
    EUILayout *one = [[self.class alloc] init];
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

- (__kindof EUILayout *)configure:(void(^)(EUILayout *))block {
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

@implementation EUILayout (Helper)

+ (EUILayout * __nullable)findNode:(EUIObject)object {
    if (!object) return nil;
    EUILayout *one = nil;
    if ([object isKindOfClass:UIView.class]) {
        one = [(UIView *)object eui_layout];
    } else if ([object isKindOfClass:EUILayout.class]) {
        one = object;
    } else {
        return nil;
    }
    return one;
}

+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <id> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
    if (items.count == 1 && [[items objectAtIndex:0] isKindOfClass:NSArray.class]) {
        items = items[0];
    }
    NSMutableArray *one = @[].mutableCopy;
    for (id item in items) {
        EUILayout *node = [EUILayout findNode:item];
        if (node) {
            [one addObject:node];
        }
    }
    return one;
}

@end

@implementation EUILayout (ForChain)

//- (__kindof EUILayout * (^)(EUILayoutSizeType))t_sizeType {
//    return ^EUILayout * (EUILayoutSizeType type) {
//        self.sizeType = type;
//        return self;
//    };
//}
//
//- (__kindof EUILayout * (^)(CGFloat))t_height {
//    return ^EUILayout * (CGFloat h) {
//        self.size = (CGSize) {self.size.width, h};
//        return self;
//    };
//}
//
//- (__kindof EUILayout * (^)(CGFloat))t_width {
//    return ^EUILayout * (CGFloat w) {
//        self.size = (CGSize) {w, self.size.height};
//        return self;
//    };
//}

//- (__kindof EUILayout * (^)(CGFloat,CGFloat,CGFloat,CGFloat))e_padding {
//    return ^EUILayout * (CGFloat t,CGFloat l,CGFloat b,CGFloat r) {
//        UIEdgeInsets insets = UIEdgeInsetsMake(t, l, b, r);
//        self.padding = insets;
//        return self;
//    };
//}
//
//- (__kindof EUILayout * (^)(CGFloat,CGFloat,CGFloat,CGFloat))t_margin {
//    return ^EUILayout * (CGFloat t,CGFloat l,CGFloat b,CGFloat r) {
//        UIEdgeInsets insets = UIEdgeInsetsMake(t, l, b, r);
//        self.margin = insets;
//        return self;
//    };
//}

@end
