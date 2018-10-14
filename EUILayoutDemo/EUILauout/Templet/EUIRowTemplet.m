//
//  EUIRowTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIRowTemplet.h"

@implementation EUIRowTemplet

- (void)layoutTemplet {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    [self reset];
    
    NSArray <EUILayout *> *nodes = self.nodes;
    NSMutableArray <EUILayout *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat totalHeight = 0;
    for (EUILayout *node in nodes) {
        if ([self isFilterNode:node]) {
            EUICalculatStatus status = (EUICalculatStatus) {
                .frame={0}, .step = (EPStepX | EPStepY)
            };
            [self layoutaSubNode:node
                      preSubNode:nil
                          status:&status
                         context:NULL];
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
        CGFloat ah = (NODE_VALID_HEIGHT(self) - totalHeight) / fillNodes.count;
        for (EUILayout *node in fillNodes) {
            node.height = ah;
        }
    }
    [self layoutNodes:nodes];
}

- (BOOL)isFilterNode:(EUILayout *)layout {
    if ((layout.sizeType & EUISizeTypeToVertFit) ||
        (EUIValid(layout.maxHeight)) ||
        (EUIValid(layout.height)))
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
    
    if (!(*step & EPStepY)) {
        CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
        if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
            NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
        }
        frame -> origin.y = EUIValue(layout.margin.top) + CGRectGetMaxY(preFrame) + EUIValue(preSubLayout.margin.bottom);
        
        *step |= EPStepY;
    }
    [super calculatePostionForSubLayout:layout
                           preSubLayout:preSubLayout
                                canvers:canvers];
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
