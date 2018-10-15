//
//  EUIParser.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIParser.h"
#import "EUITemplet.h"

#pragma mark -

#define EUIParsePackage(...) \
    [@[__VA_ARGS__] \
        enumerateObjectsUsingBlock:^ \
        (id <EUIParsing> obj, NSUInteger idx, BOOL * _Nonnull stop) { \
            [obj parse:node _:preNode _:context]; \
        }]; \

#pragma mark -

@implementation EUIParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _xParser = [EUIXParser new];
        _yParser = [EUIYParser new];
        _wParser = [EUIWParser new];
        _hParser = [EUIHParser new];
    }
    return self;
}

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUIParseContext *)context
{
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    NSInteger exceptions = 2;
    NSInteger loop = 0;
    do {
        if ((node.gravity & EUIGravityHorzEnd) || (node.gravity & EUIGravityHorzCenter)) {
            EUIParsePackage(self.wParser, self.xParser);
        } else {
            EUIParsePackage(self.xParser, self.wParser);
        }
        if ((node.gravity & EUIGravityVertEnd) || (node.gravity & EUIGravityVertCenter)) {
            EUIParsePackage(self.hParser, self.yParser);
        } else {
            EUIParsePackage(self.yParser, self.hParser);
        }
        loop ++;
        NSCAssert(loop < exceptions, @"EUIError : 异常的计算!");
    } while ((loop > exceptions) ||
         (context->step & 0xFF) != EUIParsedStepDone);
}

@end

@implementation EUIXParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepX) && !(context -> recalculate)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
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
        *step |= EUIParsedStepX;
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
        *step |= EUIParsedStepX;
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
        *step |= EUIParsedStepX;
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
        *step |= EUIParsedStepX;
    }
}

@end

@implementation EUIYParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepY) && !(context -> recalculate)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    if (context -> recalculate) {
        
    }
    
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
        *step |= EUIParsedStepY;
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
        *step |= EUIParsedStepY;
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
        *step |= EUIParsedStepY;
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
        *step |= EUIParsedStepY;
    }
}

@end

@implementation EUIWParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepW) && !(context -> recalculate)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    CGRect *frame = &(context->frame);
    
    EUITemplet *templet = node.templet;
    CGSize suggestSize = [templet suggestConstraintSize];
    
    if (EUIValid(node.size.width)) {
        frame -> size.width = node.size.width;
        *step |= EUIParsedStepW;
        return;
    }
    
    if ((EUISizeTypeToVertFit & node.sizeType) && (EUISizeTypeToHorzFit & node.sizeType)) {
        CGSize size = [node sizeThatFits:suggestSize];
        frame -> size = size;
        *step |= (EUIParsedStepH | EUIParsedStepW);
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
        *step |= EUIParsedStepW;
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
        *step |= EUIParsedStepW;
    }
}

@end

@implementation EUIHParser

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepH) && !(context -> recalculate)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    CGRect *frame = &(context->frame);
    EUITemplet *templet = node.templet;
    CGSize suggestSize = [templet suggestConstraintSize];
    
    if (EUIValid(node.size.height)) {
        frame -> size.height = node.size.height;
        *step |= EUIParsedStepH;
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
        *step |= EUIParsedStepH;
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
        *step |= EUIParsedStepH;
    }
}

@end
