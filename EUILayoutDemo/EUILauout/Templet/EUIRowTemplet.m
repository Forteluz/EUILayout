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
                .frame={0},
                .step = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepW),
                .recalculate = YES
            };
            [self.parser parse:node _:nil _:&ctx];
            if (ctx.frame.size.height == 0) {
#ifdef DEBUG
                NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", node);
#endif
            }
            ///< -------------------------- >
            node.height = ctx.frame.size.height;
            ///< -------------------------- >
            totalHeight += ctx.frame.size.height + EUIValue(node.margin.top) + EUIValue(node.margin.bottom);
        } else {
            [fillNodes addObject:node];
        }
    }
    if (fillNodes.count > 0) {
        CGFloat tw = NODE_VALID_HEIGHT(self) - EUIValue(self.padding.top) - EUIValue(self.padding.bottom);
        CGFloat ah = (tw - totalHeight) / fillNodes.count;
        for (EUINode *node in fillNodes) {
            node.height = ah;
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

- (void)parseY:(EUINode *)layout _:(EUINode *)preSubLayout _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    
    CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
    if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
        NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
    }
    if (preSubLayout) {
        frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(CGRectGetMaxY(preFrame)) + EUIValue(preSubLayout.margin.bottom);
    } else {
        frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(self.padding.top);
    }
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
        EUINode *lastOne = nil;
        for (EUINode *one in self.nodes) {
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES
            };
            [self.parser parse:one _:lastOne _:&ctx];
            ///< ----- Cache size ----- >
            one.size = ctx.frame.size;
            ///< ---------------------- >
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width = MAX(size.width, one.size.width);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height += (one.size.height + EUIValue(one.margin.top) + EUIValue(one.margin.bottom));
            }
        }
    }
    return size;
}

@end
