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
    if (one == nil) {
        one = [EUILayout layouterByView:self];
        objc_setAssociatedObject(self, kDCLayoutAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_setDelegate:(__weak id)delegate {
    self.eui_layout.delegate = delegate;
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
    [self.eui_layout clean];
}

- (void)eui_reload {
    if (!self.eui_layout.delegate) {
        NSLog(@"EUI_ERROR : 未设置代理！");
    }
    [self.eui_layout update];
}

- (void)eui_update:(EUITemplet *)templet {
    if (!templet) {
        NSCAssert(0, @"EUI_ERROR:这是一个不确定的操作，如果是清空模板，调用 eui_clean 方法！");
    }
    [self.eui_layout updateTemplet:templet];
}

@end
