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

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items {
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

#pragma mark -

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
    CGSize msize = (CGSize) {
        EUIValid(self.maxWidth) ? self.maxWidth :NODE_VALID_WIDTH(self),
        EUIValid(self.maxHeight) ? self.maxHeight : NODE_VALID_HEIGHT(self)
    };
    return msize;
}

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    [self reset];
    [self layoutNodes:self.nodes];
}

- (void)layoutNodes:(NSArray *)nodes {
    NSMutableArray <EUITemplet *> *templets = nil;
    EUILayout *lastNode = nil;
    NSInteger index = 0;
    do {
        EUILayout *layout = [nodes objectAtIndex:index];
        if (!layout) {
            return;
        }
        [layout setTemplet:self];
        
        UIView *view = [self viewForLayout:layout];
#ifdef DEBUG
        NSCAssert(view, @"EUIError: 找不到 layout:[%@] 的视图!", layout);
#endif
        ///< 强制修正视图关系------------- >
        if (view.superview) {
            if (view.superview != self.view) {
                [view removeFromSuperview];
            } else {
                [self.view bringSubviewToFront:view];
            }
        }
        if (!view.superview) {
            if (lastNode) {
                [self.view insertSubview:view aboveSubview:lastNode.view];
            } else {
                [self.view addSubview:view];
            }
        }
        ///< -------------------------- >
        ///< 视图层级管理 TODO:待修复 UIControl 系列的视图
        if ([layout zPosition] > 0 && layout.zPosition != EUILayoutZPostionDefault) {
            [view.layer setZPosition:layout.zPosition];
        }
        ///< -------------------------- >
        BOOL isTemplet = [layout isKindOfClass:EUITemplet.class];
        if ( isTemplet ) {
            if (!templets) {
                 templets = @[].mutableCopy;
            }
            EUITemplet *templet = (EUITemplet *)layout;
            [templets addObject:templet];
        }
        ///< -------------------------- >
        [self layoutaSubNode:layout
                  preSubNode:lastNode
                      status:&(EUICalculatStatus){}
                     context:NULL];
        ///< -------------------------- >
        index ++;
        lastNode = layout;
    } while (!(index >= nodes.count));
    
    if (templets.count) {
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

- (void)layoutaSubNode:(EUILayout *)node
            preSubNode:(EUILayout *)preSubNode
                status:(EUICalculatStatus *)canvers
               context:(EUICalculatContext *)context
{
    NSInteger loop = 0;
    do {
        if (!(canvers->step & EPStepX) || !(canvers->step & EPStepY)) {
            [self calculatePostionForSubLayout:node
                                  preSubLayout:preSubNode
                                       canvers:canvers];
        }
        if (!(canvers->step & EPStepW) || !(canvers->step & EPStepH)) {
            [self calculateSizeForSubLayout:node
                               preSubLayout:preSubNode
                                    canvers:canvers];
        }
        loop ++;
        if (loop >= 3) {
            NSLog(@"捕捉异常计算!!");
        }
    } while (!(loop <= 3) || (canvers->step & 0xFF) != EPStepFinished);
    
    if ( node.view ) {
        [node.view setFrame:canvers->frame];
    }
}

- (void)calculateSizeForSubLayout:(EUILayout *)layout
                     preSubLayout:(EUILayout *)preSubLayout
                          canvers:(EUICalculatStatus *)canvers
{}

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(EUICalculatStatus *)canvers
{}

#pragma mark - Node Control

- (void)addNode:(EUIObject)item {
    if (!item) {
        return;
    }
    EUILayout *node = [EUILayout findNode:item];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes.mutableCopy;
    [one addObject:node];
    _nodes = one.copy;
    
    [self layoutTemplet];
}

- (__kindof EUILayout *)nodeAtIndex:(NSInteger)index {
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index > nodes.count) {
        return nil;
    }
    return nodes[index];
}

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
