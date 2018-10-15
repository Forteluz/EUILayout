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
@property (nonatomic, copy, readwrite) NSArray <EUINode *> *nodes;
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
        _nodes = [EUINode nodesFromItems:items];
        self.isHolder = YES;
        self.sizeType = EUISizeTypeToFill;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc templet:%@", self);
}

#pragma mark -

- (void)cleanTempletSubViewsIfNeeded {
    NSInteger count = self.view.subviews.count;
    if (count == 0) {
        return;
    }
    [self.view.subviews enumerateObjectsUsingBlock:^
     (__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj.eui_node isKindOfClass:EUITemplet.class]) {
             EUITemplet *one = (EUITemplet *)obj.eui_node;
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

- (UIView *)viewForLayout:(EUINode *)layout {
    UIView *view = layout.view;
    BOOL isTempletNode = [layout isKindOfClass:EUITemplet.class];
    if ( isTempletNode && [(EUITemplet *)layout isHolder] ) {
        if (!view) {
             view = [EUITempletView new];
#ifdef DEBUG
            [view setBackgroundColor:DCRandomColor];
#endif
            [(EUITemplet *)layout setView:view];
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
    EUIAssertMainThread();
    [self reset];
    [self layoutNodes:self.nodes];
}

- (void)layoutNodes:(NSArray *)nodes {
    NSMutableArray <EUITemplet *> *templets = nil;
    EUINode *lastNode = nil;
    NSInteger index = 0;
    do {
        EUINode *layout = [nodes objectAtIndex:index];
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
        [self updateSubLayout:layout preSublayout:lastNode context:&(EUIParseContext){}];
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

- (void)calculateMaxBounds:(CGRect *)bounds byLayout:(EUINode *)layout {
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

- (void)updateSubLayout:(EUINode *)subLayout
           preSublayout:(EUINode *)preSubLayout
                context:(EUIParseContext *)context
{
    [self.parser parse:subLayout _:preSubLayout _:context];
#ifdef DEBUG
    NSCAssert(subLayout.view, @"EUIError: layout:[%@] 的 view 找不到!", subLayout);
#endif
    [subLayout.view setFrame:context -> frame];
}

#pragma mark - Node Control

- (void)addNode:(EUIObject)item {
    if (!item) {
        return;
    }
    EUINode *node = [EUINode findNode:item];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes.mutableCopy;
    [one addObject:node];
    _nodes = one.copy;
    
    [self layoutTemplet];
}

- (__kindof EUINode *)nodeAtIndex:(NSInteger)index {
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index > nodes.count) {
        return nil;
    }
    return nodes[index];
}

- (EUIParser *)parser {
    if (!_parser) {
         _parser = [EUIParser new];
    }
    return _parser;
}

#pragma mark -

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = CGSizeZero;
    EUIEdge *margin = self.margin;
    if (self.sizeType & EUISizeTypeToHorzFill) {
        size.width = constrainedSize.width - margin.left - margin.right;
    }
    if (self.sizeType & EUISizeTypeToVertFill) {
        size.height = constrainedSize.height - margin.top - margin.right;
    }
    if (self.sizeType & EUISizeTypeToFit) {
        EUINode *lastOne = nil;
        for (EUINode *one in self.nodes) {
            EUIParseContext status = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY)
            };
            [self updateSubLayout:one
                     preSublayout:lastOne
                          context:&status];
            one.size = status.frame.size;
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width = MAX(size.width, one.size.width);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, one.size.height);
            }
        }
    }
    return size;
}

#pragma mark - Setter

- (void)setView:(UIView *)view {
    [super setView:view];
    if ( view ) {
        [view eui_setNode:self];
    }
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
