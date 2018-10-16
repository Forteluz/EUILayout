//
//  EUIColumnTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIColumnTemplet.h"

@implementation EUIColumnTemplet

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        @weakify(self);
        self.parser.xParser.parsingBlock = ^
        (EUINode *node, EUINode *preNode,EUIParseContext *context)
        {
            @strongify(self);
            [self parseX:node _:preNode _:context];
        };
    }
    return self;
}

- (void)layoutTemplet {
    EUIAssertMainThread();
    [self reset];
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fills = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat __tw = 0;
    for (EUINode *node in nodes) {
        if ([self isFilterNode:node]) {
            EUIParseContext ctx = (EUIParseContext) {
                .step  = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepH),
                .recalculate = YES
            };
            [self.parser.wParser parse:node _:nil _:&ctx];
            ///< ----- Cache size ----- >
            CGRect r = {NSNotFound,NSNotFound,ctx.frame.size.width,NSNotFound};
            [node setCacheFrame:r];
            ///< ----------------------->
            __tw += r.size.width + EUIValue(node.margin.left) + EUIValue(node.margin.right);
        } else {
            [fills addObject:node];
        }
    }
    if (fills.count > 0) {
        CGFloat tw = NODE_VALID_WIDTH(self) - EUIValue(self.padding.left) - EUIValue(self.padding.right);
        CGFloat value = (tw - __tw) / fills.count;
        for (EUINode *node in fills) {
            CGFloat w = value - EUIValue(node.margin.left) - EUIValue(node.margin.right);
            CGRect r = {NSNotFound,NSNotFound,w,NSNotFound};
            [node setCacheFrame:r];
        }
    }
    [self layoutNodes:nodes];
}

- (BOOL)isFilterNode:(EUINode *)layout {
    if ((layout.sizeType & EUISizeTypeToHorzFit) ||
        (EUIValid(layout.maxWidth)) ||
        (EUIValid(layout.width)))
    {
        return YES;
    }
    return NO;
}

- (void)parseX:(EUINode *)node _:(EUINode *)preNode _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
#ifdef DEBUG
    BOOL iserr = preNode && (preNode.cacheFrame.size.width == NSNotFound);
    NSCAssert(!iserr, @"EUIError : Layout:[%@] 在 Column 模板下的 Frame 计算异常", preNode);
#endif
    frame -> origin.x = EUIValue(node.margin.left) + CGRectGetMaxX(preNode.cacheFrame);
    if (preNode) {
        frame -> origin.x += EUIValue(preNode.margin.right);
    } else {
        frame -> origin.x += EUIValue(self.padding.left);
    }
    *step |= EUIParsedStepX;
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = CGSizeZero;
    EUIEdge *margin = self.margin;
    if (self.sizeType & EUISizeTypeToHorzFill) {
        size.width = constrainedSize.width - EUIValue(margin.left) - EUIValue(margin.right);
    }
    if (self.sizeType & EUISizeTypeToVertFill) {
        size.height = constrainedSize.height - EUIValue(margin.top) - EUIValue(margin.bottom);
    }
    if (self.sizeType & EUISizeTypeToFit) {
        EUINode *preone = nil;
        for (EUINode *one in self.nodes) {
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES
            };
            [self.parser parse:one _:preone _:&ctx];
            ///< ----- Cache size ----- >
            CGRect r = {NSNotFound,NSNotFound,NSNotFound,NSNotFound};
            if (ctx.frame.size.height > 0) {
                r.size.height = ctx.frame.size.height;
            }
            if (ctx.frame.size.width > 0) {
                r.size.width = ctx.frame.size.width;
            }
            [one setCacheFrame:r];
            ///< ---------------------- >
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width += (one.size.width + EUIValue(one.margin.left) + EUIValue(one.margin.right));
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, one.size.height);
            }
            preone = one;
        }
    }
    return size;
}

@end
