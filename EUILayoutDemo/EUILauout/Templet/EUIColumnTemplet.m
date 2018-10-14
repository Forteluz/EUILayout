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
    CGFloat totalWidth = 0;
    for (EUILayout *node in nodes) {
        if ([self isFilterNode:node]) {
            EUICalculatStatus status = (EUICalculatStatus) {
                .frame={0}, .step = (EPStepX | EPStepY)
            };
            [self layoutaSubNode:node
                      preSubNode:nil
                          status:&status
                         context:NULL];
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
        for (EUILayout *node in fillNodes) {
            node.width = value;
        }
    }
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
        size.width = constrainedSize.width - EUIValue(margin.left) - EUIValue(margin.right);
    }
    if (self.sizeType & EUISizeTypeToVertFill) {
        size.height = constrainedSize.height - EUIValue(margin.top) - EUIValue(margin.bottom);
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
