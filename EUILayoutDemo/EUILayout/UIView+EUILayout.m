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

- (EUILayout *)eui_configure:(EUIConfigurationBlock)block {
    if (block) {
        block(self.eui_layout);
    }
    return self.eui_layout;
}

- (void)eui_cleanUp {
    EUITemplet *root = [self.eui_engine rootTemplet];
    if (root) {
        [self.eui_engine cleanUp];
        [self eui_releaseEngine];
    } else {
        root = self.eui_templet.rootTemplet;
        [root.view eui_cleanUp];
    }
}

- (void)eui_reload {
    EUITemplet *root = [self.eui_engine rootTemplet];
    if (root) {
        [self.eui_engine layoutTemplet:root];
    } else {
        root = self.eui_templet.rootTemplet;
        [root.view eui_reload];
    }
}

- (void)eui_lay:(EUITemplet *)templet {
    if (!templet) {
        return;
    }
    [self.eui_engine layoutTemplet:templet];
}

- (UIView *)eui_viewWithTag:(NSInteger)tag {
    UIView *root = self.eui_engine.rootTemplet.view;
    if (root) {
        return [root viewWithTag:tag];
    }
    return nil;
}

#pragma mark - Properties

#define EUIProperty(_TYPE_, _PROPERTY_) \
    - (void)setEui_##_PROPERTY_:(_TYPE_)eui_##_PROPERTY_ { \
        self.eui_layout._PROPERTY_ = eui_##_PROPERTY_; \
    } \
    - (_TYPE_)eui_##_PROPERTY_ { \
        return self.eui_layout._PROPERTY_; \
    }

EUIProperty(EUITemplet *, templet)
EUIProperty(CGFloat, x)
EUIProperty(CGFloat, y)
EUIProperty(CGFloat, width)
EUIProperty(CGFloat, height)
EUIProperty(CGFloat, maxWidth)
EUIProperty(CGFloat, minWidth)
EUIProperty(CGFloat, maxHeight)
EUIProperty(CGFloat, minHeight)
EUIProperty(CGSize,  size)
EUIProperty(CGPoint, origin)
EUIProperty(CGRect,  frame)
EUIProperty(NSString *, uniqueID)
EUIProperty(EUIEdge  *, margin)
EUIProperty(EUIGravity,  gravity)
EUIProperty(EUISizeType, sizeType)

//- (EUITemplet *)eui_templet {
//    BOOL isTempletContainer = [self isKindOfClass:EUITempletView.class];
//    if (!isTempletContainer) {
//        return self.eui_engine.rootTemplet;
//    } else {
//        return self.eui_layout.templet;
//    }
//}

- (EUIEdge *)eui_padding {
    BOOL isTempletContainer = [self isKindOfClass:EUITempletView.class];
    if (!isTempletContainer) {
        return self.eui_templet.padding;
    } else {
        return self.eui_layout.padding;
    }
}

- (void)setEui_padding:(EUIEdge *)eui_padding {
    BOOL isTempletContainer = [self isKindOfClass:EUITempletView.class];
    if (!isTempletContainer) {
        self.eui_templet.padding = eui_padding;
    } else {
        self.eui_layout.padding = eui_padding;
    }
}

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

#pragma mark - DCUILayout

- (EUILayout *)eui_layout {
    EUILayout *one = objc_getAssociatedObject(self, kDCLayoutAssociatedKey);
    if (one == nil) {
        one = [EUILayout new];
        one.view = self;
        objc_setAssociatedObject(self, kDCLayoutAssociatedKey, one, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return one;
}

- (void)eui_setNode:(EUILayout *)node {
    EUILayout *one = objc_getAssociatedObject(self, kDCLayoutAssociatedKey);
    if (!one || one != node) {
        objc_setAssociatedObject(self,
                                 kDCLayoutAssociatedKey,
                                 node,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
