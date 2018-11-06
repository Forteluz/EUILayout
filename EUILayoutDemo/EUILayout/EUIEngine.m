//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIEngine.h"
#import "UIView+EUILayout.h"

#pragma mark -

@interface EUIEngine() {
    BOOL _working;
}
@property (nonatomic, weak, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) EUITemplet *templet;
@property (nonatomic, copy) NSArray *subviews;
@end

@implementation EUIEngine

- (instancetype)initWithView:(UIView *)view {
    self = [super init];
    if (self) {
        _view = view;
        _working = NO;
    }
    return self;
}

- (void)dealloc {
    [self cleanUp];
    NSLog(@"Engine dealloc");
}

#pragma mark - Update

- (void)layoutIfNeeded {
    EUIAssertMainThread();
 
    if (!_view || !_templet)
        return;

    [self updateViewBoundsIfNeeded];
    
    if (self.view.bounds.size.width  == 0 ||
        self.view.bounds.size.height == 0) {
        return;
        NSCAssert(0, @" EUI ERROR : 容器布局时没有有效的宽或者高，请检查！");
    }
    
    ///===============================================
    /// TODO : 需要扩展成 subnodes
    ///===============================================
    NSArray *subviews = [self.templet loadSubviews];
    
    ///===============================================
    /// Diff subviews for remove or hidden
    /// TODO : 思考视图的管理是不是可以增加策略控制
    ///===============================================
    NSMutableArray <UIView *> *unuseViews = @[].mutableCopy;
    [_subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![subviews containsObject:obj]) {
            [unuseViews addObject:obj];
        }
    }];
    if ([unuseViews count]) {
        [unuseViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [obj removeFromSuperview];
            (obj = nil);
        }];
        [unuseViews removeAllObjects];
    }
    unuseViews = nil;
    
    ///< Caching
    self.subviews = subviews;
}

- (void)updateTemplet:(EUITemplet *)templet {
     _working = YES;
    ///=====================================================
    /// engine 当第三者插足 view 和 templet 的关系，
    ///===================================================
    [self setTemplet:templet];   ///< strongify templet
    [templet setView:self.view]; ///< weakify view
}

- (void)lay {
    EUITemplet *one = _templet;
    
    ///< Update templet's bounds if needed
    CGSize old = one.cacheFrame.size;
    BOOL needUpdateTempletBounds = [one needCalculate];
    if ( needUpdateTempletBounds ) {
        [self updateTempletBounds];
    }
    CGSize new = one.cacheFrame.size;

    if (needUpdateTempletBounds) {
        ///=================================================
        /// 子节点 size 改变可能影响整体布局，所以整体刷新
        ///=================================================
        BOOL isRootEngine = one.templet == nil;
        BOOL sizeDidChanged = !CGSizeEqualToSize(old, new);
        if ( sizeDidChanged && !isRootEngine) {
            EUITemplet *root = one.rootTemplet;
            [root layout];
            return;
        }
    }
    [self.templet layout];
}

- (void)updateViewBoundsIfNeeded {
    ///===============================================================
    /// update view's bounds if width or height is 0
    ///===============================================================
    CGRect r = _view.frame;
    CGSize size = r.size;
    CGSize cacheS = _view.eui_node.cacheFrame.size;

    if (!EUIValueIsValid(size.width) && EUIValueIsValid(cacheS.width)) {
        size.width = cacheS.width;
    }
    if (!EUIValueIsValid(size.height) && EUIValueIsValid(cacheS.height)) {
        size.height = cacheS.height;
    }

    r.size = size;
    _view.frame = r;
}

- (CGRect)boundsByContainer:(UIView *)view {
    return CGRectZero;
}

- (void)updateTempletBounds {
    EUITemplet *templet = self.templet;
    CGRect frame = (CGRect){.origin = {0}, .size = self.view.bounds.size};
    
    ///< Margin 的计算必须明确有父 templet 时才处理
    BOOL canCalculateMargin = templet.templet != nil;
    
    ///< Parse position x
    if (EUIValueIsValid(templet.x)) {
        frame.origin.x = templet.x;
    } else if (EUIValueIsValid(templet.margin.left)) {
        if (canCalculateMargin) {
            frame.origin.x = templet.margin.left;
        }
    }
    
    ///< Parse position y
    if (EUIValueIsValid(templet.y)) {
        frame.origin.y = templet.y;
    } else if (EUIValueIsValid(templet.margin.top)) {
        if (canCalculateMargin) {
            frame.origin.y = templet.margin.top;
        }
    }
    
    ///< Parse size width
    if (EUIValueIsValid(templet.width)) {
        frame.size.width = templet.width;
    } else if (EUIValueIsValid(templet.cacheFrame.size.width)) {
        frame.size.width = templet.cacheFrame.size.width;
    } else if (EUIValueIsValid(templet.margin.right) || EUIValueIsValid(templet.margin.left)) {
        if (canCalculateMargin) {
            frame.size.width -= EUIValue(templet.margin.left) + EUIValue(templet.margin.right);
        }
    }
    if (EUIValueIsValid(templet.maxWidth) || EUIValueIsValid(templet.minWidth)) {
        CGFloat val = frame.size.width;
        CGFloat max = EUIValueIsValid(templet.maxWidth) ? templet.maxWidth : val;
        CGFloat min = EUIValueIsValid(templet.minWidth) ? templet.minWidth : val;
        frame.size.width = EUI_CLAMP(val, min, max);
    }
    
    ///< Parse size height
    if (EUIValueIsValid(templet.height)) {
        frame.size.height = templet.height;
    } else if (EUIValueIsValid(templet.cacheFrame.size.height)) {
        frame.size.height = templet.cacheFrame.size.height;
    } else if (EUIValueIsValid(templet.margin.bottom) || EUIValueIsValid(templet.margin.top)) {
        if (canCalculateMargin) {
            frame.size.height -= EUIValue(templet.margin.top) + EUIValue(templet.margin.bottom);
        }
    }
    if (EUIValueIsValid(templet.maxHeight) || EUIValueIsValid(templet.minHeight)) {
        CGFloat val = frame.size.height;
        CGFloat max = EUIValueIsValid(templet.maxHeight) ? templet.maxHeight : val;
        CGFloat min = EUIValueIsValid(templet.minHeight) ? templet.minHeight : val;
        frame.size.height = EUI_CLAMP(val, min, max);
    }

    [templet setCacheFrame:frame];
}

- (void)cleanUp {
    EUIAssertMainThread();
    
    EUITemplet *one = self.templet;
    if (!one) return;
    if ([one isKindOfClass:EUITemplet.class]) {
        [one removeAllSubnodes];
    }
    [self removeSubviews];

    _templet = nil;
    _working = NO;
}

- (void)removeSubviews {
    if (!_subviews || !_subviews.count) {
        return;
    }
    [_subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        (obj = nil);
    }];
}

#pragma mark - Properties

- (BOOL)isWorking {
    return _working;
}

@end
