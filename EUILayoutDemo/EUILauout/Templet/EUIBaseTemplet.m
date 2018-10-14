//
//  EUIBaseTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/27.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseTemplet.h"

@implementation EUIBaseTemplet

- (instancetype)initWithItems:(NSArray <EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {

    }
    return self;
}

- (void)calculateSizeForSubLayout:(EUILayout *)layout
                     preSubLayout:(EUILayout *)preSubLayout
                          canvers:(EUICalculatStatus *)canvers
{
    EPStep *step = &(canvers->step);
    CGRect *frame = &(canvers->frame);
    CGSize suggestSize = [self suggestConstraintSize];

    if ((*step & EPStepW)) {
        goto StepH;
    }
    
    if (EUIValid(layout.size.width)) {
        frame -> size.width = layout.size.width;
        *step |= EPStepW;
        goto StepH;
    }
    
    if ((EUISizeTypeToVertFit & layout.sizeType) &&
        (EUISizeTypeToHorzFit & layout.sizeType))
    {
        CGSize size = [layout sizeThatFits:suggestSize];
        frame -> size = size;
        *step |= (EPStepH | EPStepW);
        return;
    }
    
    UpdateSizeType(layout, Horz);

    if (EUISizeTypeToHorzFit & layout.sizeType) {
        if (frame -> size.height) {
            suggestSize.height = frame -> size.height;
        } else if (EUIValid(layout.size.height)) {
            suggestSize.height = layout.size.height;
        }
        CGSize size = [layout sizeThatFits:suggestSize];
        frame -> size.width = size.width ?: suggestSize.width;
    }
    else if (EUISizeTypeToHorzFill & layout.sizeType) {
        CGFloat w = NODE_VALID_WIDTH(self) - EUIValue(layout.margin.left) - EUIValue(layout.margin.right);
        if (EUIValid(layout.maxWidth) && (frame -> size.width > layout.maxWidth)) {
            w = layout.maxWidth;
        }
        frame -> size.width = w;
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
    
    UpdateSizeType(layout, Vert)
    
    if (EUISizeTypeToVertFit & layout.sizeType) {
        if (frame -> size.width) {
            suggestSize.width = frame -> size.width;
        } else if (EUIValid(layout.size.height)) {
            suggestSize.width = layout.size.width;
        }
        CGSize size = [layout sizeThatFits:suggestSize];
        frame -> size.height = size.height ?: suggestSize.height;
    }
    else if (EUISizeTypeToVertFill & layout.sizeType) {
        CGFloat t = layout.margin.top;
        CGFloat b = layout.margin.bottom;
        CGFloat h = NODE_VALID_HEIGHT(self);
        if (EUIValid(t) && EUIValid(b)) {
            h -= t + b;
        }
        if (EUIValid(layout.maxHeight) && (frame->size.height > layout.maxHeight)) {
            h = layout.maxHeight;
        }
        frame -> size.height = h;
    } else {
        assert("Opps!!!" == NULL);
    }
    
    *step |= EPStepH;
}

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(EUICalculatStatus *)canvers
{
    EPStep *step = &(canvers->step);
    CGRect *frame = &(canvers->frame);
    
    if ((*step & EPStepX)) {
        goto StepY;
    }
    
    CGFloat sw = NODE_VALID_WIDTH(self);
    if (!sw) {
         sw = [self suggestConstraintSize].width;
    }
    CGFloat lw = frame -> size.width ?: layout.size.width;
    
    if (EUIValid(layout.origin.x)) {
        if (self.isHolder) {
            frame -> origin.x = layout.origin.x;
        } else {
            frame -> origin.x = layout.origin.x + CGRectGetMinX(self.frame);
        }
        *step |= EPStepX;
        if (!(*step & EPStepY)) {
            goto StepY;
        }
    }
    
    UpdateGravity(layout, Horz)
    
    if (layout.gravity & EUIGravityHorzStart) {
        if (self.isHolder) {
            frame -> origin.x = EUIValue(layout.margin.left) + EUIValue(self.padding.left);
        } else {
            frame -> origin.x = EUIValue(layout.margin.left) + EUIValue(self.padding.left) + CGRectGetMinX(self.frame);
        }
        *step |= EPStepX;
    }
    else if ((layout.gravity & EUIGravityHorzEnd) && EUIValid(lw) && EUIValid(sw)) {
        if (self.isHolder) {
            frame -> origin.x = sw - EUIValue(self.padding.right) - lw - EUIValue(layout.margin.right);
        } else {
            frame -> origin.x = CGRectGetMaxX(self.frame) - EUIValue(self.padding.right) - lw - EUIValue(layout.margin.right);
        }
        *step |= EPStepX;
    }
    else if (layout.gravity & EUIGravityHorzCenter) {
        if (EUIValid(sw) && EUIValid(lw)) {
            if (self.isHolder) {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1);
            } else {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1) + self.origin.x;
            }
            *step |= EPStepX;
        }
    }
    
StepY:
    if ((*step & EPStepY)) {
        return;
    }
    
    CGFloat sh = NODE_VALID_HEIGHT(self);
    if (!sh) {
        sh = [self suggestConstraintSize].height;
    }
    CGFloat lh = frame -> size.height ?: layout.size.height;
    
    if (EUIValid(layout.origin.y)) {
        frame -> origin.y = layout.origin.y;
        *step |= EPStepY;
        return;
    }
    
    UpdateGravity(layout, Vert);
    
    if (layout.gravity & EUIGravityVertStart) {
        if (self.isHolder) {
            frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(self.padding.top);
        } else {
            frame -> origin.y = EUIValue(layout.margin.top) + EUIValue(self.padding.top) + CGRectGetMinY(self.frame);
        }
        *step |= EPStepY;
    }
    else if ((layout.gravity & EUIGravityVertEnd) && EUIValid(lh) && EUIValid(sh)) {
        if (self.isHolder) {
            frame -> origin.y = sh - EUIValue(self.padding.bottom) - lh - EUIValue(layout.margin.bottom);
        } else {
            frame -> origin.y = CGRectGetMaxY(self.frame) - EUIValue(self.padding.bottom) - lh - EUIValue(layout.margin.bottom);
        }
        *step |= EPStepY;
    }
    else if (layout.gravity & EUIGravityVertCenter) {
        if (EUIValid(sh) && EUIValid(lh)) {
            if (self.isHolder) {
                frame -> origin.y = ((NSInteger)(sh - lh) >> 1);
            } else {
                frame -> origin.y = ((NSInteger)(sh - lh) >> 1) + self.origin.y;
            }
            *step |= EPStepY;
        }
    }
}

#pragma mark -

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
                size.width = MAX(size.width, one.size.width);
            }
            if (self.sizeType & EUISizeTypeToVertFit) {
                size.height = MAX(size.height, one.size.height);
            }
        }
    }
    return size;
}


@end
