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
@property (copy, readwrite) NSArray <EUILayout *> *nodes;
@end

@implementation EUITemplet

#pragma mark - Override

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items {
    EUITemplet *one = [[self.class alloc] initWithItems:items];
    return one;
}

- (instancetype)initWithItems:(NSArray <id> *)items {
    self = [super init];
    if (self) {
        _nodes = [EUILayout nodesFromItems:items];
        self.isHolder = NO;
        self.sizeType = EUISizeTypeToFill;
    }
    return self;
}

- (void)dealloc {
//    NSLog(@"dealloc templet:%@", self);
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
        EUILayout *lastOne = nil;
        for (EUILayout *one in self.nodes) {
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
    EUIAssertMainThread();
    [self willLoadSubLayouts];
    [self loadSubLayouts:self.nodes];
    [self didLoadSubLayouts];
}

- (void)willLoadSubLayouts {
    [self clearSubviewsIfNeeded];

    CGSize size = self.validSize;
    if (!EUIValueIsValid(size.width) ||
        !EUIValueIsValid(size.height) ||
        (size.width  == 0) ||
        (size.height == 0)) {
        NSCAssert(0, @"EUIError : 模板宽高有点问题！");
    }
}

- (void)didLoadSubLayouts {
    ///< TODO : 视图层级调整功能
}

- (void)loadSubLayouts:(NSArray *)nodes {
    if (!nodes || !nodes.count) {
        return;
    }
    EUILayout *preNode = nil;
    for (EUILayout *node in nodes) {
        [node setTemplet:self];
        [self loadViewIfNeededByNode:node];
        [self loadLayout:node preLayout:preNode context:NULL];
        if ([node isKindOfClass:EUITemplet.class]) {
            [(EUITemplet *)node layout];
        }
        preNode = node;
    }
}

- (void)loadLayout:(EUILayout *)node preLayout:(EUILayout *)preNode context:(EUIParseContext *)context {
    if (!context) {
         context = &(EUIParseContext){
             .constraintSize = (CGSize) {
                 self.validSize.width  - EUIValue(self.padding.left) - EUIValue(self.padding.right),
                 self.validSize.height - EUIValue(self.padding.top)  - EUIValue(self.padding.bottom)
             }
         };
    }
    [self.parser parse:node _:preNode _:context];
    CGRect r = context->frame;
    [node setCacheFrame:r];
    if ( node.view ) {
        [node.view setFrame:r];
    }
}

- (EUITemplet *)vaildContainerTemplet {
    EUITemplet *one = self;
    do {
        if (one.isHolder) {
            return one;
        }
        one = one.templet;
    } while (one);
    return one;
}

- (void)loadViewIfNeededByNode:(EUILayout *)node {
    EUITemplet *cTemplet = [self vaildContainerTemplet];
    UIView *container = cTemplet.view;
    UIView *view = node.view;

    BOOL isTempletNode = [node isKindOfClass:EUITemplet.class];
    if ( isTempletNode && [(EUITemplet *)node isHolder] ) {
        if (!view) {
            view = [EUITempletView new];
            [(EUITemplet *)node setView:view];
        }
    }
    if (view == nil) return;
    if (view.superview) {
        if (view.superview != container) {
            [view removeFromSuperview];
        } else {
            [container bringSubviewToFront:view];
        }
    }
    if (!view.superview) {
        [container addSubview:view];
    }
}

#pragma mark - Private

- (void)clearSubviewsIfNeeded {
    NSInteger count = self.view.subviews.count;
    if (count == 0) {
        return;
    }
    [self.view.subviews enumerateObjectsUsingBlock:^
     (__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj.eui_layout isKindOfClass:EUITemplet.class]) {
             EUITemplet *one = (EUITemplet *)obj.eui_layout;
             [one clearSubviewsIfNeeded];
             [one.view removeFromSuperview];
             (one.view = nil);///< release reference
         } else {
             [obj removeFromSuperview];
             (obj = nil); ///< release reference
         }
     }];
}

#pragma mark - Node Filter

- (__kindof EUILayout *)nodeWithUniqueID:(NSString *)uniqueID {
    return nil;
}

- (__kindof EUILayout *)nodeAtIndex:(NSInteger)index {
    NSArray *nodes = self.nodes;
    if (!nodes || index < 0 || index > nodes.count) {
        return nil;
    }
    return nodes[index];
}

- (void)addLayout:(EUIObject)item {
    if (!item) {
        return;
    }
    EUILayout *node = [EUILayout findNode:item];
    if (!node) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one addObject:node];
    
    [self setNodes:one.copy];
}

- (void)insertLayout:(EUIObject)node atIndex:(NSInteger)index {
    if (!node) {
        return;
    }
    index = EUI_CLAMP(index, 0, self.nodes.count - 1);
    NSMutableArray *one = _nodes.mutableCopy;
    [one insertObject:node atIndex:index];
    [self setNodes:one.copy];
}

- (void)removeLayoutAtIndex:(NSInteger)index {
    if (!_nodes || index < 0 || index > _nodes.count) {
        return;
    }
    NSMutableArray *one = _nodes ? _nodes.mutableCopy : @[].mutableCopy;
    [one removeObjectAtIndex:index];
    [self setNodes:one.copy];
}

- (void)removeAllSubLayouts {
    if (_nodes.count) {
        for (EUILayout *node in _nodes) {
            if ([node isKindOfClass:EUITemplet.class]) {
                [(EUITemplet *)node removeAllSubLayouts];
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

- (void)setView:(UIView *)view {
    [super setView:view];
    if ( view ) {
        [view eui_setNode:self];
    }
}

- (EUITemplet *)rootTemplet {
    EUITemplet *one = self;
    do {
        if (!one.templet) {
            return one;
        }
        one = one.templet;
    } while (one);
    return nil;
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
