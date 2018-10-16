//
//  EUIRowTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIRowTemplet.h"

@implementation EUIRowTemplet

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        @weakify(self);
        self.parser.yParser.parsingBlock = ^
        (EUINode *node, EUINode *preNode, EUIParseContext *context)
        {
            @strongify(self);
            [self parseY:node _:preNode _:context];
        };
    }
    return self;
}

- (void)layoutTemplet {
    EUIAssertMainThread();
    [self reset];
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat totalHeight = 0;
    for (EUINode *node in nodes) {
        if ([self isFilterNode:node]) {
            EUIParseContext ctx = (EUIParseContext) {
                .step  = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepW),
                .recalculate = YES
            };
            [self.parser.hParser parse:node _:nil _:&ctx];
            ///< ----- Cache size ----- >
            CGRect r = {NSNotFound,NSNotFound,NSNotFound,ctx.frame.size.height};
            [node setCacheFrame:r];
            ///< -------------------------- >
            totalHeight += r.size.height + EUIValue(node.margin.top) + EUIValue(node.margin.bottom);
        } else {
            [fillNodes addObject:node];
        }
    }
    if (fillNodes.count > 0) {
        CGFloat tw = NODE_VALID_HEIGHT(self) - EUIValue(self.padding.top) - EUIValue(self.padding.bottom);
        CGFloat ah = (tw - totalHeight) / fillNodes.count;
        for (EUINode *node in fillNodes) {
            CGFloat h = ah - EUIValue(node.margin.top) - EUIValue(node.margin.bottom);
            CGRect  r = {NSNotFound,NSNotFound,NSNotFound,h};
            [node setCacheFrame:r];
        }
    }
    [self layoutNodes:nodes];
}

- (BOOL)isFilterNode:(EUINode *)layout {
    if ((layout.sizeType & EUISizeTypeToVertFit) ||
        (EUIValid(layout.maxHeight)) ||
        (EUIValid(layout.height)))
    {
        return YES;
    }
    return NO;
}

- (void)parseY:(EUINode *)node _:(EUINode *)preNode _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    
    CGRect preFrame = preNode ? preNode.view.frame : CGRectZero;
    if (preNode && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
        NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preNode);
#endif
    }
    CGFloat y = 0;
    if (preNode) {
        y = EUIValue(node.margin.top) + EUIValue(CGRectGetMaxY(preFrame)) + EUIValue(preNode.margin.bottom);
    } else {
        y = EUIValue(node.margin.top) + EUIValue(self.padding.top);
    }
    frame -> origin.y = CGFloatPixelRound(y);
    *step |= EUIParsedStepY;
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
                size.width = MAX(size.width, one.size.width);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height += (one.size.height + EUIValue(one.margin.top) + EUIValue(one.margin.bottom));
            }
            preone = one;
        }
    }
    return size;
}

@end
