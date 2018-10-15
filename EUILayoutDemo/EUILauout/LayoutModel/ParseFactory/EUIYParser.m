//
//  EUIYParser.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIYParser.h"
#import "EUITemplet.h"

@implementation EUIYParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUICalculatStatus *)context
{
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    if (context -> recalculate) {
        node.y = NSNotFound;
    }
    
    EPStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    EUITemplet *templet = node.templet;
    
    CGFloat sh = NODE_VALID_HEIGHT(templet);
//    if (!sh) {
//         sh = [templet suggestConstraintSize].height;
//    }
    CGFloat lh = frame -> size.height ?: node.size.height;
    
    if (EUIValid(node.origin.y)) {
        if (templet.isHolder) {
            frame -> origin.y = node.origin.y;
        } else {
            ///< 绝对坐标暂时先支持坐标系转换处理
            frame -> origin.y = node.origin.y + EUIValue(CGRectGetMinY(templet.frame));
        }
        *step |= EPStepY;
        return;
    }
    
    if (!((node.gravity) &
          (EUIGravityVertStart | EUIGravityVertCenter | EUIGravityVertEnd)))
    {
        node.gravity |= EUIGravityVertStart;
    }
    
    if (node.gravity & EUIGravityVertStart) {
        if (templet.isHolder) {
            frame -> origin.y = EUIValue(node.margin.top) + EUIValue(templet.padding.top);
        } else {
            frame -> origin.y = EUIValue(node.margin.top) + EUIValue(templet.padding.top) + CGRectGetMinY(templet.frame);
        }
        *step |= EPStepY;
        return;
    }
    
    if ((node.gravity & EUIGravityVertEnd)) {
        if (!EUIValid(lh)) {
            NSLog(@"EUIGravityVertEnd 未获得有效的 node 高度");
            return;
        }
        if (!EUIValid(sh)) {
            NSLog(@"EUIGravityVertEnd 未获得有效的 Templet 高度");
            return;
        }
        if (templet.isHolder) {
            frame -> origin.y = sh - EUIValue(templet.padding.bottom) - lh - EUIValue(node.margin.bottom);
        } else {
            frame -> origin.y = CGRectGetMaxY(templet.frame) - EUIValue(templet.padding.bottom) - lh - EUIValue(node.margin.bottom);
        }
        *step |= EPStepY;
        return;
    }
    
    if (node.gravity & EUIGravityVertCenter) {
        if (!EUIValid(lh)) {
            NSLog(@"EUIGravityVertCenter 未获得有效的 node 高度");
            return;
        }
        if (!EUIValid(sh)) {
            NSLog(@"EUIGravityVertCenter 未获得有效的 Templet 高度");
            return;
        }
        if (templet.isHolder) {
            frame -> origin.y = ((NSInteger)(sh - lh) >> 1);
        } else {
            frame -> origin.y = ((NSInteger)(sh - lh) >> 1) + EUIValue(templet.origin.y);
        }
        *step |= EPStepY;
    }
}

@end
