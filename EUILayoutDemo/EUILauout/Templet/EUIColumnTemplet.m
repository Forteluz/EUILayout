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
        __weak typeof(self) this = self;
        self.parser.xMan.parsingBlock = ^
        (EUINode * _Nonnull node,
         EUINode * _Nonnull preNode,
         EUICalculatStatus * _Nonnull context)
        {
            [this parseX:node _:preNode _:context];
        };
    }
    return self;
}

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    [self reset];
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat totalWidth = 0;
    for (EUINode *node in nodes) {
        if ([self isFilterNode:node]) {
            EUICalculatStatus status = (EUICalculatStatus) {
                .frame={0},
                .step = (EPStepX | EPStepY | EPStepH),
                .recalculate = YES
            };
            [self.parser parse:node _:nil _:&status];
            ///< -------------------------- >
            node.width = status.frame.size.width;
            ///< -------------------------- >
            totalWidth += status.frame.size.width + EUIValue(node.margin.left) + EUIValid(node.margin.right);
        } else {
            [fillNodes addObject:node];
        }
    }
    if (fillNodes.count > 0) {
        CGFloat value = (NODE_VALID_WIDTH(self) - totalWidth) / fillNodes.count;
        for (EUINode *node in fillNodes) {
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

- (void)parseX:(EUINode *)layout _:(EUINode *)preSubLayout _:(EUICalculatStatus *)context {
    EPStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
    if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
        NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
    }
    frame -> origin.x = EUIValue(layout.margin.left) + CGRectGetMaxX(preFrame) + EUIValue(preSubLayout.margin.right);

    *step |= EPStepX;
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
            ///< -------------------------- >
            ///< 缓存已经计算过的子节点size
            if (status.frame.size.height > 0) {
                one.height = status.frame.size.height;
            }
            if (status.frame.size.width > 0) {
                one.width = status.frame.size.width;
            }
            ///< -------------------------- >
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
