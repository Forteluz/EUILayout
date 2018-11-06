//
//  EUITemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import "UIView+EUILayout.h"

@interface EUITemplet() {
    ///===============================================
    /// Templet 对于 container 是弱持有，和 Node 不同；
    /// 同 weakView 一样处理；
    ///===============================================
    __weak UIView *_container;
}
@property (nonatomic, weak) UIView *weakView;
@property (copy, readwrite) NSArray <EUINode *> *nodes;
@property (nonatomic, strong) NSMutableArray <UIView *> *subviews;
@end

@implementation EUITemplet
@synthesize view = _view;

#pragma mark - Override

- (instancetype)initWithItems:(NSArray <id> *)items {
    self = [super init];
    if (self) {
        _nodes = [EUINode nodesFromItems:items];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc templet:%@", self);
}

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
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES,
                .constraintSize = constrainedSize
            };
            [self.parser parse:one _:lastOne _:&ctx];
            ///< ----- Cache size ----- >
            CGRect r = EUIRectUndefine();;
            if (ctx.frame.size.height > 0) {
                r.size.height = ctx.frame.size.height;
            }
            if (ctx.frame.size.width > 0) {
                r.size.width = ctx.frame.size.width;
            }
            [one setCacheFrame:r];
            ///< ----------------------- >
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width = MAX(size.width, r.size.width);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, r.size.height);
            }
        }
    }
    return size;
}

#pragma mark -

- (void)layout {
    [self willLoadSubnodes];
    [self loadSubnodes:self.nodes];
    [self didLoadSubnodes];
}

- (void)willLoadSubnodes {

}

- (BOOL)isBoundsValid {
    CGSize size = self.validSize;
    if (!EUIValueIsValid(size.width) ||
        !EUIValueIsValid(size.height)) {
        return NO;
    }
    return YES;
}

- (void)didLoadSubnodes {
    if (self.didLoadSubnodesBlock) {
        self.didLoadSubnodesBlock(self);
    }
    ///< TODO : 视图层级调整功能
    ///< TODO : release...
}

- (void)loadSubnodes:(NSArray *)nodes {
    if (!nodes ||
        !nodes.count ||
        ![self isBoundsValid])
    {
        return;
    }
    EUINode *preNode = nil;
    for (EUINode *node in nodes) {
        [node setTemplet:self];
        [self loadNode:node preNode:preNode context:NULL];
        if ([node isKindOfClass:EUITemplet.class]) {
            [(EUITemplet *)node layout];
        }
        preNode = node;
    }
}

- (void)loadNode:(EUINode *)node preNode:(EUINode *)preNode context:(EUIParseContext *)context {
    if (context == NULL) {
        CGSize size = (CGSize) {
            self.validSize.width  - EUIValue(self.padding.left) - EUIValue(self.padding.right),
            self.validSize.height - EUIValue(self.padding.top)  - EUIValue(self.padding.bottom)
        };
        context = &(EUIParseContext) {
            .constraintSize = size
        };
    }
    [self.parser parse:node _:preNode _:context];
    CGRect r = context->frame;
    [node setCacheFrame:r];
}

#pragma mark -

- (UIView *)container {
    if (!_container) {
        UIView *container = nil;
        EUITemplet *one = self;
        do {
            if (one.view) {
                container = one.view;
                break;
            } else {
                one = one.templet;
            }
        } while (one != nil);
        _container = container;
    }
    return _container;
}

- (NSArray *)loadSubviews {
    EUIAssertMainThread();

    UIView *container = [self container];
    if (!container) {
        NSCAssert(0, @"找不到容器视图");
    }

    NSMutableArray *views = @[].mutableCopy;

    for (EUINode *node in _nodes) {
        if ([node isKindOfClass:EUITemplet.class]) {
            NSArray *arr = [(EUITemplet *)node loadSubviews];
            [views addObjectsFromArray:arr];
        }
        
        UIView *view = node.view;
        if (!view) {
            continue;
        }
        
        [views addObject:view];
        
        CGRect r = node.cacheFrame;
        view.frame = r;

        if ([view superview]) {
            if ([view superview] != container) {
                [view removeFromSuperview];
            } else {
                [container bringSubviewToFront:view];
            }
        }
        if (!view.superview) {
            [container addSubview:view];
        } else if (view.isHidden) {
            view.hidden = NO;
        }
    }
    
    return views.copy;
}

#pragma mark - Node Filter

- (__kindof EUINode *)nodeWithUniqueID:(NSString *)uniqueID {
    return nil;
}

- (__kindof EUINode *)nodeAtIndex:(NSInteger)index {
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index >= nodes.count) {
        return nil;
    }
    return nodes[index];
}

- (void)addNode:(EUIObject)object {
    if (!object) {
        return;
    }
    EUINode *node = [EUINode findNode:object];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one addObject:node];
    [self setNodes:one.copy];
}

- (void)insertNode:(EUIObject)object atIndex:(NSInteger)index {
    if (!object) {
        return;
    }
    EUINode *node = [EUINode findNode:object];
    if (!node) {
        return;
    }
    index = EUI_CLAMP(index, 0, self.nodes.count - 1);
    NSMutableArray *one = _nodes.mutableCopy;
    [one insertObject:node atIndex:index];
    [self setNodes:one.copy];
}

- (void)replaceNode:(EUIObject)object atIndex:(NSInteger)index {
    if (!object) {
        return;
    }
    EUINode *node = [EUINode findNode:object];
    if (!node) {
        return;
    }
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index >= nodes.count) {
        return;
    }
    if ([nodes containsObject:object]) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one replaceObjectAtIndex:index withObject:object];
}

- (void)replaceNode:(EUIObject)object atNode:(EUIObject)atNode {
    if (!object || !atNode) {
        return;
    }
    NSArray *nodes = self.nodes;
    if (!nodes || nodes.count == 0) {
        return;
    }
    if (![nodes containsObject:atNode]) {
        return;
    }
    EUINode *toNode = [EUINode findNode:atNode];
    if (!toNode) {
        return;
    }
    NSInteger index = [nodes indexOfObject:toNode];
    if (index == NSNotFound) {
        return;
    }
    EUINode *node = [EUINode findNode:object];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one replaceObjectAtIndex:index withObject:node];
    [self setNodes:one.copy];
}

- (void)removeNode:(EUIObject)object {
    if (!object) return;
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    EUINode *layout = [EUINode findNode:object];
    if (layout.isTemplet) {
        [(EUITemplet *)layout removeAllSubnodes];
    } else {
        layout.view = nil;
    }
    if ([one containsObject:layout]) {
        [one removeObject:layout];
    }
    [self setNodes:one.copy];
}

- (void)removeNodeAtIndex:(NSInteger)index {
    if (!_nodes || index < 0 || index >= _nodes.count) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one removeObjectAtIndex:index];
    [self setNodes:one.copy];
}

- (void)removeAllSubnodes {
    if (_nodes.count) {
        for (EUINode *node in _nodes) {
            if ([node isKindOfClass:EUITemplet.class]) {
                [(EUITemplet *)node removeAllSubnodes];
            } else {
                node.view = nil;
            }
        }
        _nodes = nil;
    }
}

#pragma mark - Properties

- (EUIParser *)parser {
    if (!_parser) {
         _parser = [EUIParser new];
    }
    return _parser;
}

- (void)setView:(__weak UIView *)view {
    if (_weakView != view) {
        _weakView  = view;
    }
    if (_weakView) {
        EUINode *node = view.eui_node;
        if (node != self) {
            [self inheritBy:node];
            [_weakView eui_updateNode:self];
            ///===============================================
            /// node 替换后，还要更新父 templet 里的数据结构
            ///===============================================
            EUITemplet *superT = node.templet;
            if ( superT ) {
                [superT replaceNode:self atNode:node];
            }
            node = nil;
        }
    }
}

- (UIView *)view {
    return _weakView;
}

- (EUITemplet *)rootTemplet {
    EUITemplet *one = self;
    do {
        if (!one.templet) {
            return one;
        }
        one = one.templet;
    } while (one != nil);
    return nil;
}

- (BOOL)isRoot {
    if (self.view && self.view.eui_engine.isWorking) {
        return YES;
    }
    return NO;
}

@end

@implementation EUITempletView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
#ifdef DEBUG
//        [self setBackgroundColor:EUIRandomColor];
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
