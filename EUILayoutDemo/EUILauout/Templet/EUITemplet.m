//
//  EUITemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import "UIView+EUILayout.h"

@interface EUITemplet()
@property (nonatomic, copy, readwrite) NSArray <EUILayout *> *nodes;
@end

@implementation EUITemplet

+ (instancetype)templetWithItems:(NSArray <id> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
    id one = [[self.class alloc] initWithItems:items];
    return one;
}

- (instancetype)initWithItems:(NSArray <id> *)items {
    self = [super init];
    if (self) {
        _nodes = [EUILayout nodesFromItems:items];
        self.isHolder = YES;
        self.sizeType = EUISizeTypeToFill;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc templet:%@", self);
}

#pragma mark -

///< 生命周期处理
- (void)layoutSubnodes {
    
}

#pragma mark -

- (void)updateInView:(UIView *)view {
    [self setView:view];
    if ( view ) {
        [view eui_setLayout:self];
    }
}

- (void)cleanTempletSubViewsIfNeeded {
    NSInteger count = self.view.subviews.count;
    if (count == 0) {
        return;
    }
    [self.view.subviews enumerateObjectsUsingBlock:^
     (__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj.eui_layout isKindOfClass:EUITemplet.class]) {
             EUITemplet *one = (EUITemplet *)obj.eui_layout;
             [one cleanTempletSubViewsIfNeeded];
             [one.view removeFromSuperview];
             (one.view = nil);
         } else {
             [obj removeFromSuperview];
             (obj = nil);
         }
     }];
}

- (void)insertNode:(EUIObject)item {
    if (!item) {
        return;
    }
    EUILayout *node = [EUILayout findNode:item];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes.mutableCopy;
//    [one insertObject:node atIndex:0];
    [one addObject:node];
    _nodes = one.copy;
    [self layoutTemplet];
}

- (void)reset {
    [self cleanTempletSubViewsIfNeeded];
}

- (UIView *)viewForLayout:(EUILayout *)layout {
    UIView *view = layout.view;
    BOOL isTempletNode = [layout isKindOfClass:EUITemplet.class];
    if ( isTempletNode && [(EUITemplet *)layout isHolder] ) {
        if (!view) {
             view = [EUITempletView imitateByView:nil];
            [(EUITemplet *)layout updateInView:view];
        }
    }
    return view;
}

- (CGSize)suggestConstraintSize {
    ///< 当遇到计算边缘时（bounds）,
    CGSize ssize = [(EUITemplet *)self.templet suggestConstraintSize];
    CGSize msize = (CGSize) {
        NODE_VALID_WIDTH(self) ?: ssize.width,
        NODE_VALID_HEIGHT(self) ?: ssize.height
    };
    return msize;
}

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    
    [self reset];
    
    NSMutableArray <EUITemplet *> *templets = nil;
    EUILayout *lastNode = nil;
    NSInteger index = 0;
    do {
        EUILayout *layout = [self.nodes objectAtIndex:index];
        if (!layout) {
            return;
        }
        [layout setTemplet:self];
        
        UIView *view = [self viewForLayout:layout];
#ifdef DEBUG
        NSCAssert(view, @"EUIError: 找不到 layout:[%@] 的视图!", layout);
#endif
        ///< 强制修正视图关系------------->
        if ( view.superview ) {
            [view removeFromSuperview];
        }
        if (lastNode) {
            [self.view insertSubview:view aboveSubview:lastNode.view];
        } else {
            [self.view addSubview:view];
        }
        ///< -------------------------->
        if ([layout zPosition] > 0) {
            [view.layer setZPosition:layout.zPosition];
        }
        BOOL isTemplet = [layout isKindOfClass:EUITemplet.class];
        if ( isTemplet ) {
            if (!templets) {
                 templets = @[].mutableCopy;
            }
            EUITemplet *templet = (EUITemplet *)layout;
            [templets addObject:templet];
        }
        [self layoutSubNode:layout preSubNode:lastNode];
        index ++;
        lastNode = layout;
    } while (!(index >= self.nodes.count));
    
    if (templets.count) {
        ///< 为 Yoga 等待一个 runloop 重新计算 templet (for fill)
        EUIAfter(dispatch_get_main_queue(), 0.f, ^{
            for (EUITemplet *templet in templets) {
                [templet layoutTemplet];
            }
            ///< 可以增加一个生命周期回调
        });
    } else {
        ///< 可以增加一个生命周期回调
    }
}

- (void)calculateMaxBounds:(CGRect *)bounds byLayout:(EUILayout *)layout {
    EUISizeType type = self.sizeType & 0XFF;
    if (type & EUISizeTypeToFit) {
        if (type & EUISizeTypeToHorzFit) {
            bounds -> size.width = MAX(bounds->size.width, CGRectGetMaxX(layout.view.frame));
        } else if (type & EUISizeTypeToVertFit) {
            bounds -> size.height = MAX(bounds->size.height, CGRectGetMaxY(layout.view.frame));
        } else {
#ifdef DEBUG
            NSCAssert(NO, @"EUIError: layout:[%@] 的 sizeType 异常 !", layout);
#endif
        }
    }
}

- (void)layoutSubNode:(EUILayout *)layout preSubNode:(EUILayout *)preSubNode {
    CalculatCanvers canvers = (CalculatCanvers) {
        .frame = {0},
        .step  = EPStepNone
    };
    NSInteger loop = 0;
    do {
        if (!(canvers.step & EPStepX) || !(canvers.step & EPStepY)) {
            [self calculatePostionForSubLayout:layout
                                  preSubLayout:preSubNode
                                       canvers:&canvers];
        }
        if (!(canvers.step & EPStepW) || !(canvers.step & EPStepH)) {
            [self calculateSizeForSubLayout:layout
                               preSubLayout:preSubNode
                                    canvers:&canvers];
        }
        loop ++;
        if (loop >= 3) {
            NSLog(@"捕捉异常计算!!");
        }
    } while (!(loop <= 3) || (canvers.step & 0xFF) != EPStepFinished);
    
    if ( layout.view ) {
        [layout.view setFrame:canvers.frame];
    }
}

- (void)calculateSizeForSubLayout:(EUILayout *)layout
                     preSubLayout:(EUILayout *)preSubLayout
                          canvers:(CalculatCanvers *)canvers
{}

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(CalculatCanvers *)canvers
{}

#pragma mark -

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = {0};
    return size;
}

@end

@implementation EUITempletView

+ (EUITempletView *)imitateByView:(UIView *)view {
    CGRect r = view ? view.bounds : CGRectZero;
    EUITempletView *one = [[EUITempletView alloc] initWithFrame:r];
    one.backgroundColor = DCRandomColor;
    return one;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutSubviewsBlock) {
        self.layoutSubviewsBlock();
    }
}

@end
