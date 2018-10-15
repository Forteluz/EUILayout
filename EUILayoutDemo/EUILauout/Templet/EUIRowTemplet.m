//
//  EUIRowTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIRowTemplet.h"
#import "EUIYParser.h"

@implementation EUIRowTemplet

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        __weak typeof(self) this = self;
        self.parser.yMan.parsingBlock = ^
        (EUINode * _Nonnull node,
         EUINode * _Nonnull preNode,
         EUICalculatStatus * _Nonnull context)
        {
            [this parseY:node _:preNode _:context];
        };
    }
    return self;
}

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    [self reset];
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat totalHeight = 0;
    for (EUINode *node in nodes) {
        if ([self isFilterNode:node]) {
            EUICalculatStatus status = (EUICalculatStatus) {
                .frame={0},
                .step = (EPStepX | EPStepY | EPStepW),
                .recalculate = YES
            };
            [self.parser parse:node _:nil _:&status];
            if (status.frame.size.height == 0) {
#ifdef DEBUG
                NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", node);
#endif
            }
            ///< -------------------------- >
            node.height = status.frame.size.height;
            ///< -------------------------- >
            totalHeight += status.frame.size.height + EUIValue(node.margin.top) + EUIValue(node.margin.bottom);
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

- (void)parseY:(EUINode *)layout _:(EUINode *)preSubLayout _:(EUICalculatStatus *)context {
    EPStep *step = &(context->step);
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
    *step |= EPStepY;
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
            EUICalculatStatus status = (EUICalculatStatus) {
                .step = (EPStepX | EPStepY),
                .recalculate = YES
            };
            [self.parser parse:one _:lastOne _:&status];
            one.size = status.frame.size;
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
