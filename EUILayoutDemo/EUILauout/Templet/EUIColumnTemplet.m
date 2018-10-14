//
//  EUIColumnTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIColumnTemplet.h"

@implementation EUIColumnTemplet

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    [self reset];
    
    NSArray <EUILayout *> *nodes = self.nodes;
    NSMutableArray <EUILayout *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    for (EUILayout *node in nodes) {
        if ([self isFilterNode:node]) {
            EUICalculatStatus canvers = (EUICalculatStatus) {
                .frame = {0}, .step = (EPStepX | EPStepY)
            };
            [self layoutaSubNode:node
                      preSubNode:nil
                          status:&canvers
                         context:NULL];
        } else {
            [fillNodes addObject:node];
        }
    }
    [self updateFilterNodes:fillNodes];
    [self layoutNodes:nodes];
}

- (BOOL)isFilterNode:(EUILayout *)layout {
    if ((layout.sizeType & EUISizeTypeToHorzFit) ||
        (EUIValid(layout.maxWidth)) ||
        (EUIValid(layout.width)))
    {
        return YES;
    }
    return NO;
}

- (void)updateFilterNodes:(NSArray *)fillNodes {
    if (fillNodes.count > 0) {
        CGFloat value = NODE_VALID_WIDTH(self) / fillNodes.count;
        for (EUILayout *node in fillNodes) {
            node.width = value;
        }
    }
}

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(EUICalculatStatus *)canvers
{
    EPStep *step = &(canvers->step);
    CGRect *frame = &(canvers->frame);
    
    if (!(*step & EPStepX)) {
        CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
        if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
            NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
        }
        frame -> origin.x = EUIValue(layout.margin.left) + CGRectGetMaxX(preFrame) + EUIValue(preSubLayout.margin.right);
        
        *step |= EPStepX;
    }

    [super calculatePostionForSubLayout:layout preSubLayout:preSubLayout canvers:canvers];
}

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
        EUILayout *lastOne = nil;
        for (EUILayout *one in self.nodes) {
            EUICalculatStatus status = (EUICalculatStatus) {
                .step = (EPStepX | EPStepY)
            };
            [self calculateSizeForSubLayout:one
                               preSubLayout:lastOne
                                    canvers:&status];
            one.size = status.frame.size;
            if (self.sizeType & EUISizeTypeToHorzFit) {
                size.width += (one.size.width + one.margin.left + one.margin.right);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, one.size.height);
            }
        }
    }
    return size;
}

@end
