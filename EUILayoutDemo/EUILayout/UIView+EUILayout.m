//
//  UIView+EUIEngine.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "UIView+EUILayout.h"
#import <objc/runtime.h>

#pragma mark -

static const void *kDCLayoutAssociatedKey = &kDCLayoutAssociatedKey;
static const void *kDCEngineAssociatedKey = &kDCEngineAssociatedKey;

#pragma mark -

@implementation UIView (EUILayout)

#pragma mark - Access

- (EUINode *)eui_configure:(EUIConfigurationBlock)block {
    if (block) {
        block(self.eui_node);
    }
    return self.eui_node;
}

- (void)eui_cleanup {
    [self.eui_engine cleanUp];
    [self eui_releaseEngine];
}

- (void)eui_lay:(EUITemplet *)templet {
    [self.eui_engine updateTemplet:templet];
    [self.eui_engine lay];
}

- (void)eui_layoutSubviews {
    EUITemplet *temp = (self.eui_node.isTemplet ? (EUITemplet *)self.eui_node :
                        self.eui_node.templet);
    EUITemplet *root = temp.rootTemplet;
    if ( root ) {
        [root.view.eui_engine layoutIfNeeded];
    }
}

- (void)eui_layout:(EUITemplet *)templet {
    [self eui_lay:templet];
    [self eui_layoutSubviews];
}

#pragma mark -

- (void)eui_addLayout:(EUIObject)object {
    if (self.eui_node.isTemplet) {
        EUITemplet *one = (EUITemplet *)self.eui_node;
        [one addNode:object];
        [self eui_reload];
    } else {
        NSLog(@"Error:【%@】并不是 Container!", self);
    }
}

- (void)eui_removeLayout:(EUIObject)object {
    if ([self.eui_node isTemplet]) {
        EUITemplet *one = (EUITemplet *)self.eui_node;
        [one removeNode:object];
        [self eui_reload];
    } else {
        NSLog(@"Error:【%@】并不是 Container!", self);
    }
}

- (void)eui_removeAllLayouts {
    if (self.eui_node.isTemplet) {
        if ([self.eui_engine isWorking]) {
            [self.eui_engine cleanUp];
        }
        [self eui_reload];
    }
}

- (void)eui_reload {
    [self eui_lay:self.eui_node];
    [self eui_layoutSubviews];
}

- (__kindof EUINode *)eui_nodeAtIndex:(NSInteger)index {
    EUINode *one = nil;
    if (self.eui_node.isTemplet) {
        one = [(EUITemplet *)self.eui_node nodeAtIndex:index];
    }
    return one;
}

- (void)eui_removeNode:(EUIObject)object {
    if ([self.eui_node isKindOfClass:EUITemplet.class]) {
        [(EUITemplet *)self.eui_node removeNode:object];
    }
}

#pragma mark - Properties

#define EUIProperty(_TYPE_, _PROPERTY_) \
    - (void)setEui_##_PROPERTY_:(_TYPE_)eui_##_PROPERTY_ { \
        self.eui_node._PROPERTY_ = eui_##_PROPERTY_; \
    } \
    - (_TYPE_)eui_##_PROPERTY_ { \
        return self.eui_node._PROPERTY_; \
    }

EUIProperty(CGFloat, x)
EUIProperty(CGFloat, y)
EUIProperty(CGFloat, width)
EUIProperty(CGFloat, height)
EUIProperty(CGFloat, maxWidth)
EUIProperty(CGFloat, minWidth)
EUIProperty(CGFloat, maxHeight)
EUIProperty(CGFloat, minHeight)
EUIProperty(CGSize,  size)
EUIProperty(CGRect,  frame)
EUIProperty(CGPoint, origin)
EUIProperty(EUIEdge  *, margin)
EUIProperty(EUIEdge  *, padding)
EUIProperty(NSString *, uniqueID)
EUIProperty(EUIGravity,  gravity)
EUIProperty(EUISizeType, sizeType)
EUIProperty(EUITemplet *, templet)

#pragma mark - EUIEngine

- (EUIEngine *)eui_engine {
    EUIEngine *one = objc_getAssociatedObject(self, kDCEngineAssociatedKey);
    if (one == nil) {
        one = [[EUIEngine alloc] initWithView:self];
        objc_setAssociatedObject(self, kDCEngineAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_releaseEngine {
    objc_setAssociatedObject(self, kDCEngineAssociatedKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EUINode *)eui_node {
    EUINode *one = objc_getAssociatedObject(self, kDCLayoutAssociatedKey);
    if (one == nil) {
        one = [EUINode new];
        one.view = self;
        objc_setAssociatedObject(self, kDCLayoutAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_updateNode:(EUINode *)node {
    EUINode *one = objc_getAssociatedObject(self, kDCLayoutAssociatedKey);
    if (!one || one != node) {
        objc_setAssociatedObject(self,
                                 kDCLayoutAssociatedKey,
                                 node,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
