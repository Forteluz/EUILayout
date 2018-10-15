//
//  EUIXParser.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIXParser.h"
#import "EUITemplet.h"

@implementation EUIXParser

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

    if (context -> recalculate) {
    }
    
    EUITemplet *templet = node.templet;
    CGFloat sw = NODE_VALID_WIDTH(templet);
    CGFloat lw = frame -> size.width ?: node.size.width;

    if (EUIValid(node.x)) {
        if (templet.isHolder) {
            frame -> origin.x = node.x;
        } else {
            ///< 绝对坐标暂时先支持坐标系转换处理
            frame -> origin.x = node.x + EUIValue(templet.x);
        }
        *step |= EPStepX;
        return;
    }
    
    if (!((node.gravity) &
          (EUIGravityHorzStart | EUIGravityHorzCenter | EUIGravityHorzEnd)))
    {
        node.gravity |= EUIGravityHorzStart;
    }
    
    if (node.gravity & EUIGravityHorzStart) {
        if (templet.isHolder) {
            frame -> origin.x = EUIValue(templet.padding.left) + EUIValue(node.margin.left);
        } else {
            frame -> origin.x = EUIValue(templet.padding.left) + EUIValue(node.margin.left) + EUIValue(templet.x);
        }
        *step |= EPStepX;
        return;
    }
    
    if ((node.gravity & EUIGravityHorzEnd)) {
        if (!EUIValid(lw)) {
            NSLog(@"未获得有效的 layout 宽度");
            return;
        }
        if (!EUIValid(sw)) {
            NSLog(@"未获得有效的 Templet 宽度");
            return;
        }
        if (templet.isHolder) {
            frame -> origin.x = sw - EUIValue(templet.padding.right) - lw - EUIValue(node.margin.right);
        } else {
            frame -> origin.x = EUIValue(CGRectGetMaxX(templet.frame)) - EUIValue(templet.padding.right) - lw - EUIValue(node.margin.right);
        }
        *step |= EPStepX;
        return;
    }
    
    if (node.gravity & EUIGravityHorzCenter) {
        if (EUIValid(sw) && EUIValid(lw)) {
            if (templet.isHolder) {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1);
            } else {
                frame -> origin.x = ((NSInteger)(sw - lw) >> 1) + EUIValid(templet.x);
            }
        }
         *step |= EPStepX;
    }
}

@end
