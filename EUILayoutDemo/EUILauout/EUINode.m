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
@synthesize padding = _padding;

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

- (__kindof EUINode *)configure:(void(^)(EUINode *))block {
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

@implementation EUINode (Helper)

+ (EUINode * __nullable)findNode:(EUIObject)object {
    if (!object) return nil;
    EUINode *one = nil;
    if ([object isKindOfClass:UIView.class]) {
        one = [(UIView *)object eui_node];
    } else if ([object isKindOfClass:EUINode.class]) {
        one = object;
    } else {
        return nil;
    }
    return one;
}

+ (NSArray <EUINode *> *)nodesFromItems:(NSArray <id> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
    if (items.count == 1 && [[items objectAtIndex:0] isKindOfClass:NSArray.class]) {
        items = items[0];
    }
    NSMutableArray *one = @[].mutableCopy;
    for (id item in items) {
        EUINode *node = [EUINode findNode:item];
        if (node) {
            [one addObject:node];
        }
    }
    return one;
}

@end
