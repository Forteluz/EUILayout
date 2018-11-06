//
//  EUIRowTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIRowTemplet.h"

@implementation EUIRowTemplet

#pragma mark - Override

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        @weakify(self);
        self.parser.yParser.parsingBlock = ^
        (EUINode *node, EUINode *preNode, EUIParseContext *context)
        {
            @strongify(self);
            [self parseY:node _:preNode _:context];
        };
    }
    return self;
}

- (void)willLoadSubnodes {
    [super willLoadSubnodes];
    
    if (![self isBoundsValid]) {
        if (!(self.sizeType & EUISizeTypeToVertFit)) {
            return;
        }
    }

    CGSize cache = self.cacheFrame.size;
    CGSize fits_size = (CGSize) {
        EUIValueIsValid(cache.width)  ? cache.width  : MAXFLOAT,
        EUIValueIsValid(cache.height) ? cache.height : MAXFLOAT,
    };
    [self sizeThatFits:fits_size];
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = (CGSize) {0, constrainedSize.height};

    if (constrainedSize.width  <= 0 ||
        constrainedSize.height <= 0)
    {
        return size;
    }
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];

    CGFloat fitted_h = 0;
    CGFloat inner_l  = EUIValue(self.padding.left);
    CGFloat inner_r  = EUIValue(self.padding.right);

    for (EUINode *node in nodes) {
        BOOL fit = (node.sizeType & EUISizeTypeToVertFit) ||
                    EUIValueIsValid(node.maxHeight) ||
                    EUIValueIsValid(node.height);
        if ( fit )
        {
            CGSize constraintSize = (CGSize) {
                self.validSize.width - inner_l - inner_r,
                ({
                    CGFloat h = EUIMaxSize().height;
                    if (EUIValueIsValid(node.maxHeight)) {
                        h = node.maxHeight;
                    } h;
                }),
            };
            
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES,
                .constraintSize = constraintSize
            };
            [self.parser.hParser parse:node _:nil _:&ctx];
            [self.parser.wParser parse:node _:nil _:&ctx];
            
            ///===============================================
            /// Update new cache
            ///===============================================
            CGRect r = EUIRectUndefine();
            r.size = ctx.frame.size;
            if (r.size.height <= 0) {
                NSCAssert(0, @"EUI Error : Layout fit 计算出来的高度有问题！");
            }
            [node setCacheFrame:r];

            CGFloat node_h = r.size.height;
            CGFloat node_top = EUIValue(node.margin.top);
            CGFloat node_bottom = EUIValue(node.margin.bottom);
            fitted_h += node_top + node_h + node_bottom;
            
            size.width = EUI_CLAMP(r.size.width, size.width, constrainedSize.width);
        }
        else {
            [fillNodes addObject:node];
        }
    }
    
    BOOL updateSelfIfNeeded = (self.sizeType & EUISizeTypeToVertFit);
    if ( updateSelfIfNeeded ) {
        if (fillNodes.count != 0) {
            ///===============================================
            /// 如果模板需要自撑，则所有 Node 应该都是 Fit 类型 :_)
            ///===============================================
            NSCAssert(0, @"模板自撑条件不足，以下 Nodes:[%@] 不满足条件", fillNodes);
        }

        ///< Fitting height
        CGRect r = self.cacheFrame;
        r.size.height = fitted_h;
        self.cacheFrame = r;
        
        ///< Fitting width if needed
        if ((self.sizeType & EUISizeTypeToHorzFit)) {
            r.size.width = size.width;
            self.cacheFrame = r;
        } else {
            r.size.width = constrainedSize.width;
        }
        return r.size;
    }
    
    if (fillNodes.count == 0 ||
        fitted_h > constrainedSize.height)
    {
        ///< 约束的范围过小，无法显示的 fill layout 就不计算了
        return size;
    }
    
    CGFloat inner_top = EUIValue(self.padding.top);
    CGFloat inner_bottom = EUIValue(self.padding.bottom);
    CGFloat inner_h = constrainedSize.height - inner_top - inner_bottom;
    if (inner_h <= 0) {
        ///< 可计算的约束高度太小
        return size;
    }
    
    NSUInteger count = fillNodes.count;
    CGFloat average_h = (inner_h - fitted_h) / count;
    
    for (EUINode *node in fillNodes) {
        CGFloat margin_top = EUIValue(node.margin.top);
        CGFloat margin_bottom = EUIValue(node.margin.bottom);;
        CGRect  r = EUIRectUndefine();
        CGFloat w = 0;
        CGFloat h = average_h - margin_top - margin_bottom;

        r.size.height = MAX(h, 0);
    
        CGFloat inner_w = constrainedSize.width - inner_l - inner_r;
        CGSize  constraintSize = (CGSize) { inner_w, h };
        
        EUIParseContext ctx = (EUIParseContext) {
            .step = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepH),
            .recalculate = YES,
            .constraintSize = constraintSize
        };
        [self.parser.wParser parse:node _:nil _:&ctx];

        ///===============================================
        /// Update new cache
        ///===============================================
        w = ctx.frame.size.width;
        r.size.width = w;
        [node setCacheFrame:r];

        size.width = EUI_CLAMP(w, size.width, constrainedSize.width);
    }
    return size;
}

#pragma mark - Private

- (void)parseY:(EUINode *)node _:(EUINode *)pre_node _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    CGRect pre_frame = pre_node ? pre_node.cacheFrame : CGRectZero;

    if (pre_node) {
        if (EUIValueIsUndefine(pre_frame.origin.x) ||
            EUIValueIsUndefine(pre_frame.origin.y) ||
           !EUIValueIsValid(pre_frame.size.width)  ||
           !EUIValueIsValid(pre_frame.size.height)) {
            NSString *msg = @"EUIError ==> TRow parse y 异常 : [%@ 前置 layout 的 cahce frame 错误！]";
            NSCAssert(0, msg, pre_node);
        }
    }
    
    CGFloat y = 0;
    CGFloat gap = 0;
    CGFloat top = EUIValue(node.margin.top);
    
    if (pre_node) {
        CGFloat pre_margin = EUIValue(pre_node.margin.bottom);
        CGFloat pre_bottom = EUIValue(CGRectGetMaxY(pre_frame));
        y = pre_bottom + pre_margin + gap + top;
    }
    else {
        CGFloat inner_top = EUIValue(self.padding.top);
//        CGFloat margn_top = EUIValue(self.margin.top);
        y = /*margn_top +*/ inner_top + gap + top;
        
        BOOL isVirtualContainer = !self.view;
        if ( isVirtualContainer ) {
            CGRect  r = self.cacheFrame;
            CGFloat templet_top = EUIValue(CGRectGetMinY(r));
            y += templet_top;
        }
    }
    
    frame -> origin.y = CGFloatPixelRound(y);
    *step |= EUIParsedStepY;
}

@end
