//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIEngine.h"
#import "EUITemplet.h"
#import "UIView+EUILayout.h"

#pragma mark -

NSInteger EUIRootViewTag() {
    static NSInteger tag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tag = @"lxvii".hash;
    });
    return tag;
}

#pragma mark -

@interface EUIEngine()
@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) EUITemplet *rootTemplet;
@end

@implementation EUIEngine

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}

- (void)dealloc {
    [_rootTemplet removeAllSubLayouts];
    NSLog(@"Engine dealloc");
}

#pragma mark - Update

- (void)layoutTemplet:(EUITemplet *)templet {
    self.view.eui_templet = templet;
    self.rootTemplet = templet;

    ///===============================================
    /// 暂时根模板需要支持holder，后续考虑优化方案
    ///===============================================
    templet.isHolder = YES;
    
    if ([templet isHolder]) {
        [templet setView:self.rootContainer];
    } else {
        EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
        if ( one && one.superview ) {
            [one removeFromSuperview];
             one = nil;
        }
    }
    [self copyEUIToTemplet];
    [self parseViewFrameIfNeeded];
    [self updateRootTempletFrame:templet];
    [templet layout];
}

- (void)parseViewFrameIfNeeded {
    CGRect r = self.view.frame;
    ///< Fill
    if (!EUIValueIsValid(r.size.width)) {
        EUILayout *one = self.view.eui_layout;
        if (EUIValueIsValid(one.width)) {
            r.size.width = one.width;
        }
    }
    if (!EUIValueIsValid(r.size.height)) {
        EUILayout *one = self.view.eui_layout;
        if (EUIValueIsValid(one.height)) {
            r.size.height = one.height;
        }
    }
    if (r.size.width == 0 || r.size.height == 0) {
//        NSCAssert(0, @"EUIError : 布局模板时，容器需要有明确的 size!");
    }

    if ((self.rootTemplet.sizeType & EUISizeTypeToFit)) {
        [self.rootTemplet sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGSize size = self.rootTemplet.cacheFrame.size;
        if (EUIValueIsValid(size.width)) {
            r.size.width = size.width;
        }
        if (EUIValueIsValid(size.height)) {
            r.size.height = size.height;
        }
    }
    
    self.view.frame = r;
}

- (void)updateRootTempletFrame:(EUITemplet *)templet {
    CGRect frame = (CGRect){.origin = {0}, .size = self.view.bounds.size};
    if (EUIValueIsValid(templet.x)) {
        frame.origin.x = templet.x;
    } else if (EUIValueIsValid(templet.margin.left)) {
        frame.origin.x = templet.margin.left;
    }
    if (EUIValueIsValid(templet.y)) {
        frame.origin.y = templet.y;
    } else if (EUIValueIsValid(templet.margin.top)) {
        frame.origin.y = templet.margin.top;
    }
    if (EUIValueIsValid(templet.width)) {
        frame.size.width = templet.width;
    } else if (EUIValueIsValid(templet.cacheFrame.size.width)) {
        frame.size.width = templet.cacheFrame.size.width;
    } else if (EUIValueIsValid(templet.margin.right) || EUIValueIsValid(templet.margin.left)) {
        frame.size.width -= EUIValue(templet.margin.left) + EUIValue(templet.margin.right);
    }
    if (EUIValueIsValid(templet.height)) {
        frame.size.height = templet.height;
    } else if (EUIValueIsValid(templet.cacheFrame.size.height)) {
        frame.size.height = templet.cacheFrame.size.height;
    } else if (EUIValueIsValid(templet.margin.bottom) || EUIValueIsValid(templet.margin.top)) {
        frame.size.height -= EUIValue(templet.margin.top) + EUIValue(templet.margin.bottom);
    }
    if (EUIValueIsValid(templet.maxWidth) || EUIValueIsValid(templet.minWidth)) {
        CGFloat val = frame.size.width;
        CGFloat max = EUIValueIsValid(templet.maxWidth) ? templet.maxWidth : val;
        CGFloat min = EUIValueIsValid(templet.minWidth) ? templet.minWidth : val;
        frame.size.width = EUI_CLAMP(val, min, max);
    }
    if (EUIValueIsValid(templet.maxHeight) || EUIValueIsValid(templet.minHeight)) {
        CGFloat val = frame.size.height;
        CGFloat max = EUIValueIsValid(templet.maxHeight) ? templet.maxHeight : val;
        CGFloat min = EUIValueIsValid(templet.minHeight) ? templet.minHeight : val;
        frame.size.height = EUI_CLAMP(val, min, max);
    }
    [templet setCacheFrame:frame];
    [templet.view setFrame:frame];
}

- (void)cleanUp {
    EUITemplet *one = self.rootTemplet;
    if (!one) return;
    
    if ([one isKindOfClass:EUITemplet.class]) {
        [one clearSubviewsIfNeeded];
    }
    [one removeAllSubLayouts];
    if (one.isHolder) {
        UIView *container = one.view;
        if ( container ) {
            [container removeFromSuperview];
            (container = nil);
        }
        one.view = nil;
    }
    self.rootTemplet = nil;
}

#pragma mark -

#define EUISetCopyValueIfNeeded(_VAL_) \
if (self.view.eui_##_VAL_ != self.rootTemplet._VAL_) { \
self.rootTemplet._VAL_ = self.view.eui_##_VAL_; \
}

- (void)copyEUIToTemplet {
    EUISetCopyValueIfNeeded(x)
    EUISetCopyValueIfNeeded(y)
    EUISetCopyValueIfNeeded(width)
    EUISetCopyValueIfNeeded(height)
    EUISetCopyValueIfNeeded(maxWidth)
    EUISetCopyValueIfNeeded(minWidth)
    EUISetCopyValueIfNeeded(maxHeight)
    EUISetCopyValueIfNeeded(minHeight)
    EUISetCopyValueIfNeeded(sizeType)
    EUISetCopyValueIfNeeded(gravity)
    EUISetCopyValueIfNeeded(padding.left)
    EUISetCopyValueIfNeeded(padding.top)
    EUISetCopyValueIfNeeded(padding.right)
    EUISetCopyValueIfNeeded(padding.bottom)
    EUISetCopyValueIfNeeded(margin.left)
    EUISetCopyValueIfNeeded(margin.top)
    EUISetCopyValueIfNeeded(margin.right)
    EUISetCopyValueIfNeeded(margin.bottom)
}

#pragma mark - Root Container

- (EUITempletView *)rootContainer {
    EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
    if (one == nil) {
        one = [EUITempletView new];
        one.tag = EUIRootViewTag();
        [self.view addSubview:one];
    }
    return one;
}

@end
