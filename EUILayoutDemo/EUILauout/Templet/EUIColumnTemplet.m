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
                .frame = {0},
                .step  = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepH),
                .recalculate = YES
            };
            [self.parser parse:node _:nil _:&ctx];
            ///< -------------------------- >
            node.width = ctx.frame.size.width;
            ///< -------------------------- >
            __tw += ctx.frame.size.width + EUIValue(node.margin.left) + EUIValid(node.margin.right);
        } else {
            [fills addObject:node];
        }
    }
    if (fills.count > 0) {
        CGFloat value = (NODE_VALID_WIDTH(self) - __tw) / fills.count;
        for (EUINode *node in fills) {
            node.width = value;
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

- (void)parseX:(EUINode *)layout _:(EUINode *)preSubLayout _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
    if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
        NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
    }
    frame -> origin.x = EUIValue(layout.margin.left) + CGRectGetMaxX(preFrame) + EUIValue(preSubLayout.margin.right);

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
        EUINode *lastOne = nil;
        for (EUINode *one in self.nodes) {
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES
            };
            [self.parser parse:one _:lastOne _:&ctx];
            ///< ----- Cache size ----- >
            if (ctx.frame.size.height > 0) {
                one.height = ctx.frame.size.height;
            }
            if (ctx.frame.size.width > 0) {
                one.width = ctx.frame.size.width;
            }
            ///< ---------------------- >
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width += (one.size.width + EUIValue(one.margin.left) + EUIValue(one.margin.right));
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, one.size.height);
            }
        }
    }
    return size;
}

@end
