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

#define EUIParsePackage(...) \
    [@[__VA_ARGS__] \
    enumerateObjectsUsingBlock:^ \
    (id <EUIParsing> obj, NSUInteger idx, BOOL * _Nonnull stop) { \
        [obj parse:node _:preNode _:context]; \
    }]; \

- (void)parse:(EUILayout *)node
            _:(EUILayout *)preNode
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

- (void)parse:(EUILayout *)node
            _:(EUILayout *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepX)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    CGRect cacheR  = node.cacheFrame;
    CGRect *frame  = &(context->frame);
    BOOL readCache = !(context->recalculate) && !EUIValueIsUndefine(cacheR.origin.x);
    if ( readCache ) {
        frame -> origin.x = cacheR.origin.x;
        *step |= EUIParsedStepX;
        return;
    }
    
    EUITemplet *templet = node.templet;
    if (!templet) {
        NSCAssert(0, @"EUIError : 计算 x 找不到容器模板");
    }
    
    CGRect tplt_r = templet.cacheFrame;
    if (!EUIValueIsUndefine(node.x)) {
        CGFloat x = node.x;
        if (!templet.isHolder) {
            x += EUIValue(tplt_r.origin.x);
        }
        frame -> origin.x = CGFloatPixelRound(x);
        *step |= EUIParsedStepX;
        return;
    }
    
    if (!((node.gravity) & (EUIGravityHorzStart | EUIGravityHorzCenter | EUIGravityHorzEnd))) {
        node.gravity |= EUIGravityHorzStart;
    }
    
    if (node.gravity & EUIGravityHorzStart) {
        CGFloat x = EUIValue(templet.padding.left) + EUIValue(node.margin.left);
        if (!templet.isHolder) {
            x += EUIValue(tplt_r.origin.x);
        }
        frame -> origin.x = CGFloatPixelRound(x);
        *step |= EUIParsedStepX;
        return;
    }
    
    CGFloat tplt_w = tplt_r.size.width;
    CGFloat node_w = frame->size.width ?: node.size.width;
    if ((node.gravity & EUIGravityHorzEnd)) {
        if (!EUIValueIsValid(tplt_w)) {
            NSCAssert(0, @"EUIError : x[EUIGravityHorzEnd]的计算必须依赖模板的宽");
            return;
        }
        if (!EUIValueIsValid(node_w)) {
            NSCAssert(0, @"x[EUIGravityHorzEnd] 还未获得有效的 node 宽度");
            return;
        }
        CGFloat x = 0;
        if (templet.isHolder) {
            x = tplt_w - EUIValue(templet.padding.right) - node_w - EUIValue(node.margin.right);
        } else {
            x = EUIValue(CGRectGetMaxX(tplt_r)) - EUIValue(templet.padding.right) - node_w - EUIValue(node.margin.right);
        }
        frame -> origin.x = CGFloatPixelRound(x);
        *step |= EUIParsedStepX;
        return;
    }
    
    if (node.gravity & EUIGravityHorzCenter) {
        if (!EUIValueIsValid(tplt_w)) {
            NSCAssert(0, @"EUIError : x[EUIGravityHorzEnd]的计算必须依赖模板的宽");
            return;
        }
        if (!EUIValueIsValid(node_w)) {
            NSCAssert(0, @"x[EUIGravityHorzEnd] 还未获得有效的 node 宽度");
            return;
        }
        CGFloat x = ((NSInteger)(tplt_w - node_w) >> 1);
        if (!templet.isHolder) {
            x += EUIValue(tplt_r.origin.x);
        }
        frame -> origin.x = CGFloatPixelRound(x);
        *step |= EUIParsedStepX;
    }
}

@end

@implementation EUIYParser

- (void)parse:(EUILayout *)node
            _:(EUILayout *)preNode
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
    
    CGRect cacheR  = node.cacheFrame;
    CGRect *frame  = &(context->frame);
    BOOL readCache = !(context->recalculate) && !EUIValueIsUndefine(cacheR.origin.y);
    if ( readCache ) {
        frame -> origin.y = cacheR.origin.y;
        *step |= EUIParsedStepY;
        return;
    }
    
    EUITemplet *templet = node.templet;
    if (!templet) {
        NSCAssert(0, @"EUIError : 计算 y 找不到容器模板");
    }
    
    CGRect tplt_r = templet.cacheFrame;
    if (!EUIValueIsUndefine(node.y)) {
        CGFloat y = node.y;
        if (!templet.isHolder) {
            y += EUIValue(tplt_r.origin.y);
        }
        frame -> origin.y = CGFloatPixelRound(y);
        *step |= EUIParsedStepY;
        return;
    }

    if (!((node.gravity) & (EUIGravityVertStart | EUIGravityVertCenter | EUIGravityVertEnd))) {
        node.gravity |= EUIGravityVertStart;
    }
    
    if (node.gravity & EUIGravityVertStart) {
        CGFloat y = EUIValue(node.margin.top) + EUIValue(templet.padding.top);;
        if (!templet.isHolder) {
            y += EUIValue(CGRectGetMinY(tplt_r));
        }
        frame -> origin.y = CGFloatPixelRound(y);
        *step |= EUIParsedStepY;
        return;
    }
    
    CGFloat tplt_h = tplt_r.size.height;
    CGFloat node_h = frame->size.height ?: node.size.height;
    
    if ((node.gravity & EUIGravityVertEnd)) {
        if (!EUIValueIsValid(tplt_h)) {
            NSCAssert(0, @"EUIError : x[EUIGravityVertEnd]的计算必须依赖模板的高");
            return;
        }
        if (!EUIValueIsValid(node_h)) {
            NSCAssert(0, @"x[EUIGravityVertEnd] 还未获得有效的 node 高");
            return;
        }
        if (templet.isHolder) {
            frame -> origin.y = tplt_h - EUIValue(templet.padding.bottom) - node_h - EUIValue(node.margin.bottom);
        } else {
            frame -> origin.y = EUIValue(CGRectGetMaxY(tplt_r)) - EUIValue(templet.padding.bottom) - node_h - EUIValue(node.margin.bottom);
        }
        *step |= EUIParsedStepY;
        return;
    }
    
    if (node.gravity & EUIGravityVertCenter) {
        if (!EUIValueIsValid(tplt_h)) {
            NSCAssert(0, @"EUIError : x[EUIGravityVertEnd]的计算必须依赖模板的高");
            return;
        }
        if (!EUIValueIsValid(node_h)) {
            NSCAssert(0, @"x[EUIGravityVertEnd] 还未获得有效的 node 高");
            return;
        }
        CGFloat y = ((NSInteger)(tplt_h - node_h) >> 1);
        if (!templet.isHolder) {
            y += EUIValue(tplt_r.origin.y);
        }
        frame -> origin.y = y;
        *step |= EUIParsedStepY;
    }
}

@end

@implementation EUIWParser

- (void)parse:(EUILayout *)node
            _:(EUILayout *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepW)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    CGRect *frame = &(context->frame);
    
    CGRect cacheR = node.cacheFrame;
    if (!(context -> recalculate) && !EUIValueIsUndefine(cacheR.size.width)) {
        frame -> size.width = cacheR.size.width;
        *step |= EUIParsedStepW;
        return;
    }

    if (EUIValueIsValid(node.size.width)) {
        frame -> size.width = node.size.width;
        *step |= EUIParsedStepW;
        return;
    }
    
    CGSize constraintSize = context->constraintSize;
    if (!EUIValueIsValid(constraintSize.width) || constraintSize.width == 0) {
        NSCAssert(0, @"EUIError : 计算的约束宽值异常!");
    }
    
    if ((EUISizeTypeToVertFit & node.sizeType) && (EUISizeTypeToHorzFit & node.sizeType)) {
        CGSize size = [node sizeThatFits:constraintSize];
        if (size.width == 0 || size.height == 0) {
            NSCAssert(0, @"EUIError : sizeThatFits 计算结果异常! node:[%@]", node);
        }
        frame -> size = size;
        *step |= (EUIParsedStepH | EUIParsedStepW);
        return;
    }
    
    if (!(node.sizeType & (EUISizeTypeToHorzFill | EUISizeTypeToHorzFit))) {
        node.sizeType |= EUISizeTypeToHorzFill;
    }
    
    CGFloat w = 0;
    CGFloat inner = EUIValue(node.margin.left) + EUIValue(node.margin.right);
    
    if (EUISizeTypeToHorzFill & node.sizeType) {
        w = constraintSize.width - inner;
        if (w < 0) {
            w = 0;
        }
    }
    else if (EUISizeTypeToHorzFit & node.sizeType) {
        if (frame -> size.height) {
            constraintSize.height = frame -> size.height;
        } else if (EUIValueIsValid(node.size.height)) {
            constraintSize.height = node.size.height;
        } else if (!EUIValueIsValid(constraintSize.height)) {
             NSCAssert(0, @"EUIError : Fit宽需要一个合适的约束高");
        }
        constraintSize.width -= inner;
        if (constraintSize.width <= 0) {
            NSCAssert(0, @"EUIError : Fit约束宽太小");
        }
        CGSize size = [node sizeThatFits:constraintSize];
        w = size.width + inner;
    }
    
    CGFloat max = EUIValueIsValid(node.maxWidth) ? node.maxWidth : w;
    CGFloat min = EUIValueIsValid(node.minWidth) ? node.minWidth : w;
    w = EUI_CLAMP(w, min, max);
    
    if (w <= 0) {
        NSCAssert(0, @"EUIError : 宽获取异常");
    }
    frame -> size.width = w;
    *step |= EUIParsedStepW;
}

@end

@implementation EUIHParser

- (void)parse:(EUILayout *)node
            _:(EUILayout *)preNode
            _:(EUIParseContext *)context
{
    EUIParsedStep *step = &(context->step);
    if ((*step & EUIParsedStepH)) {
        return;
    }
    
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    CGRect *frame = &(context->frame);
    CGRect cacheR = node.cacheFrame;
    if (!(context -> recalculate) && !EUIValueIsUndefine(cacheR.size.height)) {
        frame -> size.height = cacheR.size.height;
        *step |= EUIParsedStepH;
        return;
    }
    
    if (EUIValueIsValid(node.size.height)) {
        frame -> size.height = node.size.height;
        *step |= EUIParsedStepH;
        return;
    }
    
    if (!(node.sizeType & (EUISizeTypeToVertFill | EUISizeTypeToVertFit))) {
        node.sizeType |= EUISizeTypeToVertFill;
    }
    
    CGSize constraintSize = context->constraintSize;
    if (!EUIValueIsValid(constraintSize.height) || constraintSize.height == 0) {
        NSCAssert(0, @"EUIError : 计算的约束高值异常! %f", constraintSize.height);
    }
    
    CGFloat h = 0;
    CGFloat inner = EUIValue(node.margin.top) + EUIValue(node.margin.bottom);

    if (EUISizeTypeToVertFill & node.sizeType) {
        h = constraintSize.height - inner;
        if (h < 0) {
            h = 0;
        }
    }
    else if (EUISizeTypeToVertFit & node.sizeType)
    {
        if (EUIValueIsValid(frame->size.width)) {
            constraintSize.width = frame->size.width;
        } else if (EUIValueIsValid(node.size.width)) {
            constraintSize.width = node.size.width;
        } else if (!EUIValueIsValid(constraintSize.width)){
            NSCAssert(0, @"EUIError : Fit高需要一个合适的约束宽");
        }
        constraintSize.height -= inner;
        if (constraintSize.height <= 0) {
            NSCAssert(0, @"EUIError : Fit约束高太小");
        }
        CGSize size = [node sizeThatFits:constraintSize];
        h = size.height + inner;
    }

    CGFloat max = EUIValueIsValid(node.maxHeight) ? node.maxHeight : h;
    CGFloat min = EUIValueIsValid(node.minHeight) ? node.minHeight : h;
    h = EUI_CLAMP(h, min, max);
    
    if (h < 0) {
#ifdef DEBUG
        h = 1.f / EUIScreenScale();
        NSCAssert(0, @"EUIError : 高获取异常 h : %f", h);
#endif
    }
    frame -> size.height = h;
    *step |= EUIParsedStepH;
}

@end
