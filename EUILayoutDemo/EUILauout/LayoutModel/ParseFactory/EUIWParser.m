//
//  EUIWMan.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIWParser.h"
#import "EUITemplet.h"

@implementation EUIWParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUICalculatStatus *)context
{
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    EPStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    
    EUITemplet *templet = node.templet;
    CGSize suggestSize = [templet suggestConstraintSize];
    
    if (EUIValid(node.size.width)) {
        frame -> size.width = node.size.width;
        *step |= EPStepW;
        return;
    }
    
    if ((EUISizeTypeToVertFit & node.sizeType) && (EUISizeTypeToHorzFit & node.sizeType)) {
        CGSize size = [node sizeThatFits:suggestSize];
        frame -> size = size;
        *step |= (EPStepH | EPStepW);
        return;
    }
    
    if (!(node.sizeType & (EUISizeTypeToHorzFill | EUISizeTypeToHorzFit))) {
        EUISizeType type = templet.sizeType & (EUISizeTypeToHorzFill | EUISizeTypeToHorzFit);
        if (type != EUISizeTypeNone) {
            node.sizeType |= type;
        } else {
            node.sizeType |= EUISizeTypeToHorzFill;
        }
    }

    if (EUISizeTypeToHorzFit & node.sizeType) {
        if (frame -> size.height) {
            suggestSize.height = frame -> size.height;
        } else if (EUIValid(node.size.height)) {
            suggestSize.height = node.size.height;
        }
        CGSize size = [node sizeThatFits:suggestSize];
        if (size.width == 0) {
            if (EUIValid(node.maxWidth)) {
                size.width = node.maxWidth;
            }
        }
        frame -> size.width = size.width;
        *step |= EPStepW;
        return;
    }
    
    if (EUISizeTypeToHorzFill & node.sizeType) {
        CGFloat margin  = EUIValue(node.margin.left) + EUIValue(node.margin.right);
        CGFloat padding = EUIValue(templet.padding.left) + EUIValue(templet.padding.right);
        CGFloat w = NODE_VALID_WIDTH(templet) - margin - padding;
        if (EUIValid(node.maxWidth) && (frame -> size.width > node.maxWidth)) {
            w = node.maxWidth;
        }
        frame -> size.width = w;
        *step |= EPStepW;
    }
}

@end
