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

- (void)eui_creatLayouterByDelegate:(__weak id)delegate {
    EUILayouter *one = [self eui_layouter];
    if (one == nil) {
        one = [EUILayouter layouterByView:self];
        objc_setAssociatedObject(self, kDCLayouterAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (one.dataSource != delegate) {
        one.dataSource  = delegate;
    }
}

#pragma mark - DCUILayoutNode

- (EUILayout *)eui_layout {
    EUILayout *one = objc_getAssociatedObject(self, kDCLayoutNodeAssociatedKey);
    if (one == nil) {
        one = [EUILayout node:self];
        objc_setAssociatedObject(self, kDCLayoutNodeAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_setLayout:(EUILayout *)layoutNode {
    EUILayout *one = objc_getAssociatedObject(self, kDCLayoutNodeAssociatedKey);
    if (!one || one != layoutNode) {
        objc_setAssociatedObject(self,
                                 kDCLayoutNodeAssociatedKey,
                                 layoutNode,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)eui_configure:(EUIConfigurationBlock)block {
    if (block) {
        block(self.eui_layout);
    }
}

@end
