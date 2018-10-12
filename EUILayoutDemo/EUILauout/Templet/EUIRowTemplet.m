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
    
    if (fillNodes.count > 0) {
        CGFloat ah = NODE_VALID_HEIGHT(self) / fillNodes.count;
        for (EUILayout *node in fillNodes) {
            node.height = ah;
        }
    }
    
    [self layoutNodes:nodes];
}

- (BOOL)isFilterNode:(EUILayout *)layout {
    return (layout.sizeType & EUISizeTypeToVertFit);
}

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(EUICalculatStatus *)canvers
{
    EPStep *step = &(canvers->step);
    CGRect *frame = &(canvers->frame);
    
    if (*step & EPStepY) {
        /**
         *  x 坐标和水平对其走老逻辑
         */
        [super calculatePostionForSubLayout:layout preSubLayout:preSubLayout canvers:canvers];

        return;
    }
    
    /**
     *  Row 模板忽略 layout 在垂直方向的对其方式，其始终依靠上一个 Layout
     */
    CGRect preFrame = preSubLayout ? preSubLayout.view.frame : CGRectZero;
    if (preSubLayout && CGRectEqualToRect(CGRectZero, preFrame)) {
#ifdef DEBUG
        NSCAssert(NO, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preSubLayout);
#endif
    }
    
    frame -> origin.y = EUIValue(layout.margin.top) + CGRectGetMaxY(preFrame) + EUIValue(preSubLayout.margin.bottom);
    *step |= EPStepY;
}

//- (void)calculateSizeForSubLayout:(EUILayout *)layout
//                     preSubLayout:(EUILayout *)preSubLayout
//                          canvers:(CalculatCanvers *)canvers
//{
//    EPStep *step = &(canvers->step);
//    CGRect *frame = &(canvers->frame);
//    CGSize suggestSize = [self suggestConstraintSize];
//
//    if ((*step & EPStepW)) {
//        goto StepH;
//    }
//
//    if (EUIValid(layout.size.width)) {
//        frame -> size.width = layout.size.width;
//        *step |= EPStepW;
//        goto StepH;
//    }
//
//    EUISizeType type = layout.sizeType;
//    if (EUIValid(layout.maxWidth)) {
//        suggestSize.width = layout.maxWidth;
//    }
//    if (EUIValid(layout.maxHeight)) {
//        suggestSize.height = layout.maxHeight;
//    }
//    if ((EUISizeTypeToVertFit & type) && (EUISizeTypeToHorzFit & type)) {
//        ///< TODO : 需要增加 margin 和 padding 的计算修正处理
//        CGSize size = [layout sizeThatFits:suggestSize];
//        frame -> size = size;
//        *step |= (EPStepH | EPStepW);
//        return;
//    }
//
//    if (EUISizeTypeToHorzFit & layout.sizeType) {
//        if (frame -> size.height) {
//            suggestSize.height = frame -> size.height;
//        } else if (EUIValid(layout.size.height)) {
//            suggestSize.height = layout.size.height;
//        }
//        ///< TODO : w 的 margin 和 padding 计算修正
//        CGSize size = [layout sizeThatFits:suggestSize];
//        if (size.width <= 0) {
//#ifdef DEBUG
//            ///< 除了 UIView 外，其他Node都应该实现 sizeThatFits：方法
//            BOOL isView = [layout.view isMemberOfClass:UIView.class];
//            NSCAssert(isView, @"EUIError : Layout:[%@] 未实现 sizeThatFits: 方法", layout);
//#endif
//            size.width = suggestSize.width;
//        }
//        frame -> size.width = size.width;
//    }
//    else if (EUISizeTypeToHorzFill & layout.sizeType) {
//        CGFloat l = layout.margin.left;
//        CGFloat r = layout.margin.right;
//        CGFloat w = NODE_VALID_WIDTH(self);
//        frame -> size.width = w;
//        if (EUIValid(l) && EUIValid(r)) {
//            frame -> size.width -= l + r;
//        }
//        if (EUIValid(layout.maxWidth) && (frame->size.width > layout.maxWidth)) {
//            frame -> size.width = layout.maxWidth;
//        }
//    }
//
//    *step |= EPStepW;
//
//StepH:
//    if ((*step & EPStepH)) {
//        return;
//    }
//
//    if (EUIValid(layout.size.height)) {
//        frame -> size.height = layout.size.height;
//        *step |= EPStepH;
//        return;
//    }
//
//    if (EUISizeTypeToVertFit & layout.sizeType) {
//        if (frame -> size.width) {
//            suggestSize.width = frame -> size.width;
//        } else if (EUIValid(layout.size.height)) {
//            suggestSize.width = layout.size.width;
//        }
//        ///< TODO : h 的 margin 和 padding 计算修正
//        CGSize size = [layout sizeThatFits:suggestSize];
//        if (size.height <= 0) {
//#ifdef DEBUG
//            ///< 除了 UIView 外，其他Node都应该实现 sizeThatFits：方法
//            BOOL isView = [layout.view isMemberOfClass:UIView.class];
//            NSCAssert(isView, @"EUIError : Layout:[%@] 未实现 sizeThatFits: 方法", layout);
//#endif
//            size.height = suggestSize.height;
//        }
//        frame -> size.height = size.height;
//    }
//    else if (EUISizeTypeToVertFill & layout.sizeType) {
//        CGFloat t = layout.margin.top;
//        CGFloat b = layout.margin.bottom;
//        CGFloat h = NODE_VALID_HEIGHT(self);
//        frame -> size.height = h;
//        if (EUIValid(t) && EUIValid(b)) {
//            frame -> size.height -= t + b;
//        }
//        if (EUIValid(layout.maxHeight) && (frame->size.height > layout.maxHeight)) {
//            frame -> size.height = layout.maxHeight;
//        }
//    } else {
//        assert("Opps!!!" == NULL);
//    }
//
//    *step |= EPStepH;
//}

//- (void)layoutTemplet {
//    [super layoutTemplet];
//
//    void (^configBlock)(YGLayout *) = ^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        layout.isIncludedInLayout = YES;
//        layout.flexWrap = YGWrapNoWrap;
//        layout.alignItems = YGAlignStretch;
//        layout.justifyContent = YGJustifyFlexStart;
//        layout.flexDirection = YGFlexDirectionColumn;
//        layout.position = YGPositionTypeRelative;
//        YOGA_SET_MARGIN(layout, self.margin);
//        YOGA_SET_PADDING(layout, self.padding);
//    };
//    [self.view configureLayoutWithBlock:configBlock];
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
//}
//
//- (void)layoutSubNode:(EUILayout *)node preSubNode:(EUILayout *)preSubNode {
//    void (^configBlock)(YGLayout *) = ^(YGLayout *layout) {
//        layout.isEnabled = YES;
//        if (EUISizeTypeToFit == node.sizeType) {
//            [self layoutNodeBased:node yoga:layout];
//        } else {
//            [self layoutTempletBased:node yoga:layout];
//        }
//        YOGA_SET_MARGIN(layout, node.margin);
//        YOGA_SET_PADDING(layout, node.padding);
//    };
//    [node.view configureLayoutWithBlock:configBlock];
//}
//
//- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout {
//    CGFloat w = NODE_VALID_WIDTH(node);
//    CGFloat h = NODE_VALID_HEIGHT(node);
//
//    ///< 自动计算宽度
//    if (w == 0) {
//        CGFloat sw = YOGA_VALID_WIDTH(self.view);
//        CGFloat se = NODE_RL_EDGE_METHOD(self, padding);
//        CGFloat ne = NODE_RL_EDGE_METHOD(node, margin);
//        w = sw - se - ne;
//    }
//
//    if (w > 0) layout.width  = YGPointValue(w);
//    if (h > 0) layout.height = YGPointValue(h);
//
//    if (node.maxHeight) {
//        layout.maxHeight = YGPointValue(node.maxHeight);
//    }
//    if (node.maxWidth) {
//        layout.maxWidth = YGPointValue(node.maxWidth);
//    }
//
//    layout.flexGrow = h == 0 ? 1 : 0;
//    layout.flexShrink = h == 0 ? 1 : 0;
//    layout.alignSelf = YGAlignFlexStart;
//}
//
//- (void)layoutTempletBased:(EUILayout *)node yoga:(YGLayout *)layout {
////    CGFloat w = YOGA_VALID_WIDTH(self.view) -
////    NODE_RL_EDGE_METHOD(self, padding) -
////    NODE_RL_EDGE_METHOD(node, margin);
////    layout.width = YGPointValue(w);
//    layout.flexGrow = 1;
//    layout.flexShrink = 1;
//    layout.alignSelf = YGAlignStretch;
//}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = CGSizeZero;
    return size;
}

@end
