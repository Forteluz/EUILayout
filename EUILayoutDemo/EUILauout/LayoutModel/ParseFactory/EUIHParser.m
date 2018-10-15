//
//  EUIHParser.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIHParser.h"
#import "EUITemplet.h"

@implementation EUIHParser

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
    
    if (EUIValid(node.size.height)) {
        frame -> size.height = node.size.height;
        *step |= EPStepH;
        return;
    }
    
    if (!(node.sizeType & (EUISizeTypeToVertFill | EUISizeTypeToVertFit))) {
        EUISizeType type = templet.sizeType & (EUISizeTypeToVertFill | EUISizeTypeToVertFit);
        if (type != EUISizeTypeNone) {
            node.sizeType |= type;
        } else {
            node.sizeType |= EUISizeTypeToVertFill;
        }
    }
    
    if (EUISizeTypeToVertFit & node.sizeType) {
        if (frame -> size.width) {
            suggestSize.width = frame -> size.width;
        } else if (EUIValid(node.size.height)) {
            suggestSize.width = node.size.width;
        }
        CGSize size = [node sizeThatFits:suggestSize];
        if (size.height == 0) {
            if (EUIValid(node.maxHeight)) {
                size.height = node.maxHeight;
            }
        }
        frame -> size.height = size.height;
        *step |= EPStepH;
        return;
    }
    
    if (EUISizeTypeToVertFill & node.sizeType) {
        CGFloat margin  = EUIValue(node.margin.top) - EUIValue(node.margin.bottom);
        CGFloat padding = EUIValue(templet.padding.top) + EUIValue(templet.padding.bottom);
        CGFloat h = NODE_VALID_HEIGHT(templet) - margin - padding;
        if (EUIValid(node.maxHeight) && (frame->size.height > node.maxHeight)) {
            h = node.maxHeight;
        }
        frame -> size.height = h;
        *step |= EPStepH;
    }
}

@end
