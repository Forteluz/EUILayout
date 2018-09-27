//
//  EUIBaseTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/27.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseTemplet.h"

UIKIT_STATIC_INLINE CGFloat EUIValue(CGFloat one) {
    return (one == NSNotFound) ? 0 : one;
}

UIKIT_STATIC_INLINE CGFloat EUIValid(CGFloat one) {
    return one != NSNotFound;
}

typedef enum : unsigned short {
    _PStepX = 1 << 1, ///< has Parsed origin.x
    _PStepY = 1 << 2, ///< has Parsed origin.y
    _PStepW = 1 << 3, ///< has Parsed size.width
    _PStepH = 1 << 4  ///< has Parsed size.height
} _PStep;

@implementation EUIBaseTemplet

- (void)layoutNode:(EUILayout *)node {
    CGRect frame = CGRectZero;
    _PStep step = 0;

    BOOL (^isFinished)(_PStep) = ^(_PStep one){
        if ((one & _PStepX) &&
            (one & _PStepY) &&
            (one & _PStepW) &&
            (one & _PStepH) )
        {
            return YES;
        }
        return NO;
    };
    
    [self parseNode:node frame:&frame curStep:&step];

    if (!isFinished(step)) {
//        NSCParameterAssert(@"parse error!!!!");
        NSLog(@"parse error!!!!");
    }
    
    [node setFrame:frame];
    if ( node.view ) {
        [node.view setFrame:frame];
    }
}

- (void)parseNode:(EUILayout *)layout frame:(CGRect *)frame curStep:(_PStep *)step {
    [self parsePostion:layout frame:frame step:step];
    [self parseSize:layout frame:frame step:step];

    if (!(*step & _PStepX) || !(*step & _PStepY)) {
        [self parseNode:layout frame:frame curStep:step];
    }
    if (!(*step & _PStepW) || !(*step & _PStepH)) {
        [self parseSize:layout frame:frame step:step];
    }
}

#pragma mark - Parse Postion left & right

- (void)parsePostion:(EUILayout *)layout frame:(CGRect *)frame step:(_PStep *)step {
    if ((*step & _PStepX)) {
        goto StepY;
    }
    
    if (EUIValid(layout.origin.x)) {
        if (self.isHolder) {
            frame->origin.x = layout.origin.x;
        } else {
            frame->origin.x = layout.origin.x + CGRectGetMinX(self.frame);
        }
        *step |= _PStepX;
        
        if (!(*step & _PStepY)) {
            goto StepY;
        }
    }

    if (EUIValid(self.origin.x) &&
        EUILayoutAlignStart == layout.hAlign)
    {
        if (self.isHolder) {
            frame->origin.x = EUIValue(layout.margin.left) + EUIValue(self.padding.left);
        } else {
            frame->origin.x = EUIValue(layout.margin.left) + EUIValue(self.padding.left) + CGRectGetMinX(self.frame);
        }
        *step |= _PStepX;
    }
    else if (EUILayoutAlignEnd == layout.hAlign &&
             EUIValid(layout.size.width) &&
             EUIValid(self.size.width))
    {
        if (self.isHolder) {
            frame->origin.x = CGRectGetWidth(self.frame) - EUIValue(self.padding.right) - layout.size.width - EUIValue(layout.margin.right);
        } else {
            frame->origin.x = CGRectGetMaxX(self.frame) - EUIValue(self.padding.right) - layout.size.width - EUIValue(layout.margin.right);
        }
        *step |= _PStepX;
    }
    else /*EUILayoutAlignCenter*/ {
        if (EUIValid(self.size.width) && EUIValid(layout.size.width)) {
            if (self.isHolder) {
                frame->origin.x = (self.size.width - layout.size.width) * 0.5;
            } else {
                frame->origin.x = (self.size.width  - layout.size.width) * 0.5 + self.origin.x;
            }
            *step |= _PStepX;
        }
    }
    
StepY:
    if ((*step & _PStepY)) {
        return;
    }
    
    if (EUIValid(layout.origin.y)) {
        frame -> origin.y = layout.origin.y;
        *step |= _PStepY;
        return;
    }
    
    if (EUILayoutAlignStart == self.vAlign) {
        if (self.isHolder) {
            frame->origin.y = EUIValue(layout.margin.top) + EUIValue(self.padding.top);
        } else {
            frame->origin.y = EUIValue(layout.margin.top) + EUIValue(self.padding.top) + CGRectGetMinY(self.frame);
        }
        *step |= _PStepY;
    }
    else if (EUILayoutAlignEnd == layout.vAlign &&
             EUIValid(layout.size.height) &&
             EUIValid(self.size.height))
    {
        if (self.isHolder) {
            frame->origin.y = self.size.height - EUIValue(self.padding.bottom) - layout.size.height - EUIValue(layout.margin.bottom);
        } else {
            frame->origin.y = CGRectGetMaxY(self.frame) - EUIValue(self.padding.bottom) - layout.size.height - EUIValue(layout.margin.bottom);
        }
        *step |= _PStepY;
    }
    else /*EUILayoutAlignCenter*/ {
        if (EUIValid(self.size.height) && EUIValid(layout.size.height)) {
            if (self.isHolder) {
                frame->origin.y = (self.size.height - layout.size.height) * 0.5;
            } else {
                frame->origin.y = (self.size.height  - layout.size.height) * 0.5 + self.origin.y;
            }
            *step |= _PStepY;
        }
    }
}

#pragma mark - Parse Postion top & bottom

- (void)parseSize:(EUILayout *)layut frame:(CGRect *)frame step:(_PStep *)step {
    if (self.size.width != NSNotFound) {
        frame -> size.width = self.size.width;
        *step = _PStepW;
    }
    if (!(*step & _PStepW)) {
        
    }
    if (self.size.height != NSNotFound) {
        frame -> size.height = self.size.height;
        *step = _PStepH;
    }
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    return CGSizeZero;
}


@end
