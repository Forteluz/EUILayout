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
@property (copy, readwrite) NSArray <EUINode *> *nodes;

/**
 *  暂时使用holder做强引用延长临时变量的生命周期
 *  TODO : 补充详细说明
 */
@property (nonatomic, strong) NSArray *holder;
@end

@implementation EUITemplet

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
    EUITemplet *one = [[self.class alloc] initWithItems:items];
    one.holder = items;
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
             (one.view = nil);///< close reference
         } else {
             [obj removeFromSuperview];
             (obj = nil); ///< close reference
         }
     }];
}

- (void)releaseHolder {
    if (_holder) {
        _holder = nil;
    }
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
        if ( isTemplet ) {
            [(EUITemplet *)layout layoutTemplet];
        }
        ///< -------------------------- >
        index ++;
        lastNode = layout;
    } while (!(index >= nodes.count));
}

- (void)updateSubLayout:(EUINode *)subLayout
           preSublayout:(EUINode *)preSubLayout
                context:(EUIParseContext *)context
{
    [self.parser parse:subLayout _:preSubLayout _:context];
    CGRect r = context -> frame;
    [subLayout setCacheFrame:r];
    [subLayout.view setFrame:r];
}

#pragma mark - Calculate Size

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = CGSizeZero;
    EUIEdge *margin = self.margin;
    if (self.sizeType & EUISizeTypeToHorzFill) {
        size.width = constrainedSize.width - EUIValue(margin.left) - EUIValue(margin.right);
    }
    if (self.sizeType & EUISizeTypeToVertFill) {
        size.height = constrainedSize.height - EUIValue(margin.top) - EUIValue(margin.right);
    }
    if (self.sizeType & EUISizeTypeToFit) {
        EUINode *lastOne = nil;
        for (EUINode *one in self.nodes) {
            if (!one.templet) {
                 one.templet = self;
            }
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES
            };
            [self.parser parse:one _:lastOne _:&ctx];
            ///< ----- Cache size ----- >
            CGRect r = (CGRect){NSNotFound,NSNotFound,NSNotFound,NSNotFound};
            if (ctx.frame.size.height > 0) {
                r.size.height = ctx.frame.size.height;
            }
            if (ctx.frame.size.width > 0) {
                r.size.width = ctx.frame.size.width;
            }
            [one setCacheFrame:r];
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

- (__kindof EUINode *)nodeWithUniqueID:(NSString *)uniqueID {
    return nil;
}

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
}

- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index {
    if (!node) {
        return;
    }
    index = EUI_CLAMP(index, 0, self.nodes.count - 1);
    NSMutableArray *one = _nodes.mutableCopy;
    [one insertObject:node atIndex:index];
    [self setNodes:one.copy];
}

- (void)removeNodeAtIndex:(NSInteger)index {
    if (!_nodes || index < 0 || index > _nodes.count) {
        return;
    }
    NSMutableArray *one = _nodes.mutableCopy;
    [one removeObjectAtIndex:index];
    [self setNodes:one.copy];
}

- (void)removeAllNodes {
    [self releaseHolder];
    
    if (_nodes.count) {
        for (EUINode *node in _nodes) {
            if ([node isKindOfClass:EUITemplet.class]) {
                [(EUITemplet *)node removeAllNodes];
            } else {
                node.view = nil;
            }
        }
        _nodes = nil;
    }
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

- (void)dealloc {
    NSLog(@"EUITempletView:%@ dealloc", self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.layoutSubviewsBlock) {
        self.layoutSubviewsBlock();
    }
}

@end
