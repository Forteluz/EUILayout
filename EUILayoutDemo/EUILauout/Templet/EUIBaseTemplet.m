//
//  EUIBaseTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/27.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseTemplet.h"

#pragma mark -

UIKIT_STATIC_INLINE CGFloat EUIValue(CGFloat one) {
    return (one == NSNotFound) ? 0 : one;
}

UIKIT_STATIC_INLINE CGFloat EUIValid(CGFloat one) {
    return one != NSNotFound;
}

typedef enum : unsigned short {
    EPStepX = 1 << 0, ///< has Parsed origin.x
    EPStepY = 1 << 1, ///< ... origin.y
    EPStepW = 1 << 2, ///< ... size.width
    EPStepH = 1 << 3  ///< ... size.height
} EPStep;

@implementation EUIBaseTemplet

- (void)layoutNode:(EUILayout *)node {
    CGRect frame = {0};
    EPStep step  = 0;

    [self parseNode:node frame:&frame curStep:&step];

    if ((step != 0x00F)) {
        assert("Parse error!!!" == NULL);
    }
    if ( node.view ) {
        [node.view setFrame:frame];
    }
}

- (void)parseNode:(EUILayout *)layout frame:(CGRect *)frame curStep:(EPStep *)step {
    [self parsePostionWithNode:layout fromNode:self frame:frame step:step];
    [self parseSize:layout frame:frame step:step];

    if (!(*step & EPStepX) || !(*step & EPStepY)) {
        [self parseNode:layout frame:frame curStep:step];
    }
    if (!(*step & EPStepW) || !(*step & EPStepH)) {
        [self parseNode:layout frame:frame curStep:step];
    }
}

#pragma mark - Parse Postion left & right

- (void)parsePostionWithNode:(EUILayout *)layout
                    fromNode:(EUILayout *)fromNode
                       frame:(CGRect *)frame
                        step:(EPStep *)step
{
    if ((*step & EPStepX)) {
        goto StepY;
    }
    
    CGFloat sw = NODE_VALID_WIDTH(fromNode);
    CGFloat lw = frame -> size.width ?: layout.size.width;
    
    if (EUIValid(layout.origin.x)) {
        if (fromNode.isHolder) {
            frame -> origin.x = layout.origin.x;
        } else {
            frame -> origin.x = layout.origin.x + CGRectGetMinX(fromNode.frame);
        }
        *step |= EPStepX;
        
        if (!(*step & EPStepY)) {
            goto StepY;
        }
    }
    
    if (EUILayoutAlignStart == layout.hAlign) {
        if (fromNode.isHolder) {
            frame -> origin.x = EUIValue(layout.margin.left) + EUIValue(fromNode.padding.left);
        } else {
            frame -> origin.x = EUIValue(layout.margin.left) + EUIValue(fromNode.padding.left) + CGRectGetMinX(fromNode.frame);
        }
        *step |= EPStepX;
    }
    else if (EUILayoutAlignEnd == layout.hAlign &&
             EUIValid(lw) &&
             EUIValid(sw)) {
        if (fromNode.isHolder) {
            frame -> origin.x = sw - EUIValue(fromNode.padding.right) - lw - EUIValue(layout.margin.right);
        } else {
            frame -> origin.x = CGRectGetMaxX(fromNode.frame) - EUIValue(fromNode.padding.right) - lw - EUIValue(layout.margin.right);
        }
        *step |= EPStepX;
    }
    else {
        if (EUIValid(sw) && EUIValid(lw)) {
            if (fromNode.isHolder) {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1);
            } else {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1) + fromNode.origin.x;
            }
            *step |= EPStepX;
        }
    }
    
StepY:
    if ((*step & EPStepY)) {
        return;
    }
    
    CGFloat sh = NODE_VALID_HEIGHT(fromNode);
    CGFloat lh = frame -> size.height ?: layout.size.height;
    
    if (EUIValid(layout.origin.y)) {
        frame -> origin.y = layout.origin.y;
        *step |= EPStepY;
        return;
    }
    
    if (EUILayoutAlignStart == layout.vAlign) {
        if (fromNode.isHolder) {
            frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(fromNode.padding.top);
        } else {
            frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(fromNode.padding.top) + CGRectGetMinY(fromNode.frame);
        }
        *step |= EPStepY;
    }
    else if (EUILayoutAlignEnd == layout.vAlign &&
             EUIValid(lh) &&
             EUIValid(sh))
    {
        if (fromNode.isHolder) {
            frame -> origin.y = sh - EUIValue(fromNode.padding.bottom) - lh - EUIValue(layout.margin.bottom);
        } else {
            frame -> origin.y = CGRectGetMaxY(fromNode.frame) - EUIValue(fromNode.padding.bottom) - lh - EUIValue(layout.margin.bottom);
        }
        *step |= EPStepY;
    }
    else {
        if (EUIValid(sh) && EUIValid(lh)) {
            if (fromNode.isHolder) {
                frame -> origin.y = ((NSInteger)(sh - lh) >> 1);
            } else {
                frame -> origin.y = ((NSInteger)(sh - lh) >> 1) + fromNode.origin.y;
            }
            *step |= EPStepY;
        }
    }
}

#pragma mark - Parse Postion top & bottom

- (void)parseSize:(EUILayout *)layout frame:(CGRect *)frame step:(EPStep *)step {
    if ((*step & EPStepW)) {
        goto StepH;
    }
    
    if (EUIValid(layout.size.width)) {
        frame -> size.width = layout.size.width;
        *step |= EPStepW;
        goto StepH;
    }
    
    BOOL isMaxFits = NO;
    if (EUILayoutSizeToFit == layout.sizeType) {
        CGFloat h = MAXFLOAT;
        if (frame -> size.height) {
            h = frame -> size.height;
        } else if (EUIValid(layout.size.height)) {
            h = layout.size.height;
        } else {
            isMaxFits = YES;
        }
        CGSize s = [layout sizeThatFits:(CGSize){MAXFLOAT, h}];
        if (isMaxFits) {
            frame -> size = s;
            *step |= EPStepH;
        } else {
            frame -> size.width = s.width;
        }
    } else if (EUILayoutSizeToFill == layout.sizeType) {
        CGFloat l = layout.margin.left;
        CGFloat r = layout.margin.right;
        frame -> size.width = NODE_VALID_WIDTH(self) - l - r;
    } else {
        assert("Opps!!!" == NULL);
    }
    
    *step |= EPStepW;
    
StepH:
    if ((*step & EPStepH)) {
        return;
    }
    
    if (EUIValid(layout.size.height)) {
        frame -> size.height = layout.size.height;
        *step |= EPStepH;
        return;
    }

    if (EUILayoutSizeToFit == layout.sizeType) {
        CGFloat w = MAXFLOAT;
        if (frame -> size.width) {
            w = frame -> size.width;
        } else if (EUIValid(layout.size.width)) {
            w = layout.size.width;
        }
        CGSize s = [layout sizeThatFits:(CGSize){w, MAXFLOAT}];
        frame -> size.height = s.height;
    } else if (EUILayoutSizeToFill == layout.sizeType) {
        CGFloat t = layout.margin.top;
        CGFloat b = layout.margin.bottom;
        frame -> size.height = NODE_VALID_HEIGHT(self) - t - b;
    } else {
        assert("Opps!!!" == NULL);
    }
    
    *step |= EPStepH;
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    return CGSizeZero;
}


@end
