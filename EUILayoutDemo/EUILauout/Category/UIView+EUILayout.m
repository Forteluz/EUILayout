//
//  UIView+EUILayout.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "UIView+EUILayout.h"
#import <objc/runtime.h>

#pragma mark -

static const void *kDCLayouterAssociatedKey = &kDCLayouterAssociatedKey;
static const void *kDCLayoutNodeAssociatedKey = &kDCLayoutNodeAssociatedKey;
static const void *kDCLayoutYogaAssociatedKey = &kDCLayoutYogaAssociatedKey;

#pragma mark -

@implementation UIView (EUILayout)

#pragma mark - EUILayouter

- (EUILayouter *)eui_layouter {
    EUILayouter *one = objc_getAssociatedObject(self, kDCLayouterAssociatedKey);
    return one;
}

- (void)eui_creatLayouter {
    EUILayouter *one = [self eui_layouter];
    if (one == nil) {
        one = [EUILayouter layouterByView:self];
        objc_setAssociatedObject(self, kDCLayouterAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)eui_setDelegate:(__weak id)delegate {
    EUILayouter *one = [self eui_layouter];
    if (one == nil) {
        one = [EUILayouter layouterByView:self];
        objc_setAssociatedObject(self, kDCLayouterAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (one.delegate != delegate) {
        one.delegate  = delegate;
    }
}

#pragma mark - DCUILayoutNode

- (EUINode *)eui_node {
    EUINode *one = objc_getAssociatedObject(self, kDCLayoutNodeAssociatedKey);
    if (one == nil) {
        one = [EUINode node:self];
        objc_setAssociatedObject(self, kDCLayoutNodeAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_setNode:(EUINode *)node {
    EUINode *one = objc_getAssociatedObject(self, kDCLayoutNodeAssociatedKey);
    if (!one || one != node) {
        objc_setAssociatedObject(self,
                                 kDCLayoutNodeAssociatedKey,
                                 node,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (EUINode *)eui_configure:(EUIConfigurationBlock)block {
    if (block) {
        block(self.eui_node);
    }
    return self.eui_node;
}

- (void)eui_reload {
    [self.eui_layouter update];
}

- (void)eui_update:(EUITemplet *)templet {
    [self.eui_layouter updateTemplet:templet];
}

@end
