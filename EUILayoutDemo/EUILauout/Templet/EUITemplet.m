//
//  EUITemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import "EUINode+Filter.h"
#import "UIView+EUILayout.h"

@interface EUITemplet()
@property (copy, readwrite) NSArray <EUINode *> *nodes;
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
            [(EUITemplet *)layout setView:view];
        }
    }
    return view;
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

#pragma mark - Calculate Size

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
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY)
            };
            [self.parser parse:one _:lastOne _:&ctx];
            ///< ----- Cache size ----- >
            one.size = ctx.frame.size;
            ///< ----------------------- >
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

#pragma mark -

- (CGSize)suggestConstraintSize {
    CGSize msize = (CGSize) {
        EUIValid(self.maxWidth) ? self.maxWidth :NODE_VALID_WIDTH(self),
        EUIValid(self.maxHeight) ? self.maxHeight : NODE_VALID_HEIGHT(self)
    };
    return msize;
}

#pragma mark - Node Filter

- (__kindof EUINode *)nodeAtIndex:(NSInteger)index {
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index > nodes.count) {
        return nil;
    }
    return nodes[index];
}

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
    
    [self setNodes:one.copy];
    [self layoutTemplet];
}

- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index {
    if (!node) {
        return;
    }
    index = EUI_CLAMP(index, 0, self.nodes.count - 1);
    
    NSMutableArray *one = _nodes.mutableCopy;
    [one insertObject:node atIndex:index];
    [self setNodes:one.copy];
    [self layoutTemplet];
}

- (void)removeNodeAtIndex:(NSInteger)index {
    if (!_nodes || index < 0 || index > _nodes.count) {
        return;
    }
    NSMutableArray *one = _nodes.mutableCopy;
    [one removeObjectAtIndex:index];
    [self setNodes:one.copy];
    [self layoutTemplet];
}

#pragma mark - Getter

- (EUIParser *)parser {
    if (!_parser) {
         _parser = [EUIParser new];
    }
    return _parser;
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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
#ifdef DEBUG
        [self setBackgroundColor:EUIRandomColor];
#endif
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutSubviewsBlock) {
        self.layoutSubviewsBlock();
    }
}

@end
