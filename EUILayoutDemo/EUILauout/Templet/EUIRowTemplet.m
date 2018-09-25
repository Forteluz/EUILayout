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
    [self layoutRowTemplet];
}

- (void)layoutRowTemplet {
    void (^configBlock)(YGLayout *) = ^(YGLayout *layout) {
        layout.isEnabled = YES;
        layout.isIncludedInLayout = YES;
        layout.flexWrap = YGWrapWrap;
        layout.alignItems = YGAlignStretch;
        layout.justifyContent = YGJustifyFlexStart;
        layout.flexDirection = YGFlexDirectionRow;
        YOGASetMargin(layout, self.margin);
        YOGASetPadding(layout, self.padding);
    };
    [self.view configureLayoutWithBlock:configBlock];
    [self.view.yoga applyLayoutPreservingOrigin:YES];
}

- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout {
    CGFloat w = NODE_VALID_WIDTH(node);
    CGFloat h = NODE_VALID_HEIGHT(node);
    if (h == 0) {
        h = YOGA_VALID_HEIGHT(self.view) - NODE_TB_EDGE_METHOD(self, padding) - NODE_TB_EDGE_METHOD(node, margin);
    }
    if (w > 0) layout.width = YGPointValue(w);
    if (h > 0) layout.height = YGPointValue(h);
    layout.flexGrow = w == 0 ? 1 : 0;
    layout.flexShrink = w == 0 ? 1 : 0;
    layout.alignSelf = YGAlignFlexStart;
}


@end
