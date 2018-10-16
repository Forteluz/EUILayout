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

static const void *kDCNodeAssociatedKey = &kDCNodeAssociatedKey;
static const void *kDCLayoutAssociatedKey = &kDCLayoutAssociatedKey;

#pragma mark -

@implementation UIView (EUILayout)

#pragma mark - EUILayouter

- (EUILayout *)eui_layout {
    EUILayout *one = objc_getAssociatedObject(self, kDCLayoutAssociatedKey);
    return one;
}

- (void)eui_creatLayouter {
    EUILayout *one = [self eui_layout];
    if (one == nil) {
        one = [EUILayout layouterByView:self];
        objc_setAssociatedObject(self, kDCLayoutAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)eui_setDelegate:(__weak id)delegate {
    EUILayout *one = [self eui_layout];
    if (one == nil) {
        one = [EUILayout layouterByView:self];
        objc_setAssociatedObject(self, kDCLayoutAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (one.delegate != delegate) {
        one.delegate  = delegate;
    }
}

#pragma mark - DCUILayoutNode

- (EUINode *)eui_node {
    EUINode *one = objc_getAssociatedObject(self, kDCNodeAssociatedKey);
    if (one == nil) {
        one = [EUINode node:self];
        objc_setAssociatedObject(self, kDCNodeAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_setNode:(EUINode *)node {
    EUINode *one = objc_getAssociatedObject(self, kDCNodeAssociatedKey);
    if (!one || one != node) {
        objc_setAssociatedObject(self,
                                 kDCNodeAssociatedKey,
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

- (void)eui_clean {
    EUITemplet *one = self.eui_layout.rootTemplet;
    if ([one isKindOfClass:EUITemplet.class]) {
        [one reset];
    }
    [one removeAllNodes];
    if (one.isHolder) {
        UIView *container = one.view;
        if (container) {
            [container removeFromSuperview];
            (container = nil);
        }
        one.view = nil;
    }
}

- (void)eui_reload {
    [self.eui_layout update];
}

- (void)eui_update:(EUITemplet *)templet {
    [self.eui_layout updateTemplet:templet];
}

@end
