//
//  EUIColumnTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIColumnTemplet.h"

@implementation EUIColumnTemplet

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        @weakify(self);
        self.parser.xParser.parsingBlock = ^
        (EUINode *node, EUINode *preNode,EUIParseContext *context)
        {
            @strongify(self);
            [self parseX:node _:preNode _:context];
        };
    }
    return self;
}

- (void)willLoadSubnodes {
    [super willLoadSubnodes];
    if (![self isBoundsValid]) {
        if (!(self.sizeType & EUISizeTypeToHorzFit)) {
            return;
        }
    }
    [self sizeThatFits:self.cacheFrame.size];
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = (CGSize){constrainedSize.width, 0};
    if (!EUIValueIsValid(constrainedSize.width) ||
        !EUIValueIsValid(constrainedSize.height))
    {
        return size;
    }
    
    CGFloat innerVertSide = EUIValue(self.padding.top) + EUIValue(self.padding.bottom);
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat fitWidth = 0;
    for (EUINode *node in nodes) {
        BOOL needFit = (node.sizeType & EUISizeTypeToHorzFit) || EUIValueIsValid(node.maxWidth) || EUIValueIsValid(node.width);
        if ( needFit ) {
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES,
                .constraintSize = (CGSize) {
                    ({
                        CGFloat w = EUIMaxSize().width;
                        if (EUIValueIsValid(node.maxWidth)) {
                            w = node.maxWidth;
                        } w;
                    }),
                    self.validSize.height - innerVertSide
                }
            };
            [self.parser.hParser parse:node _:nil _:&ctx];
            [self.parser.wParser parse:node _:nil _:&ctx];
            ///< -------------------------- >
            CGRect r = EUIRectUndefine();{
                r.size = ctx.frame.size;
            }
            [node setCacheFrame:r];
            ///< -------------------------- >
            fitWidth += r.size.width + EUIValue(node.margin.left) + EUIValue(node.margin.right);
            size.height = EUI_CLAMP(r.size.height, size.height, constrainedSize.height);
        } else {
            [fillNodes addObject:node];
        }
    }
    
    BOOL updateSelfIfNeeded = self.sizeType & EUISizeTypeToHorzFit;
    if ( updateSelfIfNeeded ) {
        if (fillNodes.count != 0) {
            NSCAssert(0, @"fit计算条件不够，以下 fillNodes:[%@] 的高度无法获知", fillNodes);
        }
        CGRect r = self.cacheFrame;
        r.size.width = fitWidth;
        self.cacheFrame = r;
        if ((self.sizeType & EUISizeTypeToVertFit)) {
            r.size.height = size.height;
            self.cacheFrame = r;
        } else {
            r.size.height = constrainedSize.height;
        }
        return r.size;
    }
    
    if (fillNodes.count == 0 ||
        fitWidth > constrainedSize.width)
    {
        ///< 如果约束过小，无法显示的fill单位就不计算了
        return size;
    }
    
    CGFloat innerHorzSide = EUIValue(self.padding.left) + EUIValue(self.padding.right);
    CGFloat innerWidth = constrainedSize.width - innerHorzSide;
    if (innerWidth <= 0) {
        NSCAssert(0, @"constrainedSize太小了！");
    }
    
    CGFloat aw  = (innerWidth - fitWidth) / fillNodes.count;
    for (EUINode *node in fillNodes) {
        CGFloat min = 1.f;
        CGFloat h = 0;
        CGRect  r = EUIRectUndefine();
        CGFloat w = aw - EUIValue(node.margin.left) - EUIValue(node.margin.right);

        if (w < min) {
            w = h = min;
            r.size = (CGSize) {w, h};
            [node setCacheFrame:r];
            continue;
        } else {
            r.size.width = w;
        }
        
        EUIParseContext ctx = (EUIParseContext) {
            .step = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepW),
            .recalculate = YES,
            .constraintSize = (CGSize) {w, constrainedSize.height - innerVertSide}
        };
        [self.parser.hParser parse:node _:nil _:&ctx];
        h = ctx.frame.size.height;{
            r.size.height = h;
        }
        [node setCacheFrame:r];
        size.height = EUI_CLAMP(h, size.height, constrainedSize.height);
    }
    
    return size;
}

- (void)parseX:(EUINode *)node _:(EUINode *)pre_node _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    CGRect pre_frame = pre_node ? pre_node.cacheFrame : CGRectZero;
    
    if (pre_node) {
        if (EUIValueIsUndefine(pre_frame.origin.x) ||
            EUIValueIsUndefine(pre_frame.origin.y) ||
            !EUIValueIsValid(pre_frame.size.width)  ||
            !EUIValueIsValid(pre_frame.size.height)) {
            NSString *msg = @"EUIError ==> TColumb parse x 异常 : [%@ 前置 layout 的 cahce frame 错误！]";
            NSCAssert(0, msg, pre_node);
        }
    }

    CGFloat x = 0;
    CGFloat gap = 0;
    CGFloat left = EUIValue(node.margin.left);
    
    if (pre_node) {
        CGFloat pre_margin_right = EUIValue(pre_node.margin.right);
        CGFloat pre_frame_right = EUIValue(CGRectGetMaxX(pre_frame));
        x = pre_frame_right + pre_margin_right + gap + left;
    }
    else {
        CGFloat inner_left = EUIValue(self.padding.left);
//        CGFloat margn_left = EUIValue(self.margin.left);
        x = /*margn_left +*/ inner_left + gap + left;
        
        BOOL isVirtualContainer = !self.view;
        if ( isVirtualContainer ) {
            CGRect  r = self.cacheFrame;
            CGFloat templet_left = EUIValue(CGRectGetMinX(r));
            x += templet_left;
        }
    }
    
    frame -> origin.x = CGFloatPixelRound(x);
    *step |= EUIParsedStepX;
}

@end
