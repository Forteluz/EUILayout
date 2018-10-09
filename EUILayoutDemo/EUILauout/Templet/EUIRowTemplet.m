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
    [super layoutTemplet];
    [self layoutColumnTemplet];
}

- (void)layoutColumnTemplet {
    void (^configBlock)(YGLayout *) = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        layout.flexWrap = YGWrapNoWrap;
        layout.alignItems = YGAlignStretch;
        layout.justifyContent = YGJustifyFlexStart;
        layout.flexDirection = YGFlexDirectionColumn;
        layout.position = YGPositionTypeRelative;
        YOGA_SET_MARGIN(layout, self.margin);
        YOGA_SET_PADDING(layout, self.padding);
    };
    [self.view configureLayoutWithBlock:configBlock];
    [self.view.yoga applyLayoutPreservingOrigin:YES];
}

- (void)layoutNode:(EUILayout *)node {
    void (^configBlock)(YGLayout *) = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        if (EUISizeTypeToFit == node.sizeType) {
            [self layoutNodeBased:node yoga:layout];
        } else {
            [self layoutTempletBased:node yoga:layout];
        }
        YOGA_SET_MARGIN(layout, node.margin);
        YOGA_SET_PADDING(layout, node.padding);
    };
    [node.view configureLayoutWithBlock:configBlock];
}

- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout {
    CGFloat w = NODE_VALID_WIDTH(node);
    CGFloat h = NODE_VALID_HEIGHT(node);

    ///< 自动计算宽度
    if (w == 0) {
        CGFloat sw = YOGA_VALID_WIDTH(self.view);
        CGFloat se = NODE_RL_EDGE_METHOD(self, padding);
        CGFloat ne = NODE_RL_EDGE_METHOD(node, margin);
        w = sw - se - ne;
    }
    
    if (w > 0) layout.width  = YGPointValue(w);
    if (h > 0) layout.height = YGPointValue(h);
    
    layout.flexGrow = h == 0 ? 1 : 0;
    layout.flexShrink = h == 0 ? 1 : 0;
    layout.alignSelf = YGAlignFlexStart;
}

- (void)layoutTempletBased:(EUILayout *)node yoga:(YGLayout *)layout {
//    CGFloat w = YOGA_VALID_WIDTH(self.view) -
//    NODE_RL_EDGE_METHOD(self, padding) -
//    NODE_RL_EDGE_METHOD(node, margin);
//    layout.width = YGPointValue(w);
    layout.flexGrow = 1;
    layout.flexShrink = 1;
    layout.alignSelf = YGAlignStretch;
}

@end
