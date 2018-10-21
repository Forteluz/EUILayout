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

- (void)layoutWillStart {
    [super layoutWillStart];
    [self sizeThatFits:self.cacheFrame.size];
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = (CGSize){0, constrainedSize.height};
    if (!EUIValueIsValid(constrainedSize.width) ||
        !EUIValueIsValid(constrainedSize.height))
    {
        return size;
    }
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSMutableArray <EUINode *> *fillNodes = [NSMutableArray arrayWithCapacity:nodes.count];
    CGFloat fitHeight = 0;
    for (EUINode *node in nodes) {
        BOOL needFit = (node.sizeType & EUISizeTypeToVertFit) ||
        EUIValueIsValid(node.maxHeight) ||
        EUIValueIsValid(node.height);
        if ( needFit ) {
            EUIParseContext ctx = (EUIParseContext) {
                .step = (EUIParsedStepX | EUIParsedStepY),
                .recalculate = YES,
                .constraintSize = (CGSize) {
                    self.validSize.width - [self innerHorzSide], EUIMaxSize().height
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
            fitHeight += r.size.height + EUIValue(node.margin.top) + EUIValue(node.margin.bottom);
            size.width = EUI_CLAMP(r.size.width, size.width, constrainedSize.width);
        } else {
            [fillNodes addObject:node];
        }
    }
    
    if (fillNodes.count == 0 ||
        fitHeight > constrainedSize.height)
    {
        ///< 如果约束过小，无法显示的fill单位就不计算了
        return size;
    }
    
    CGFloat innerHeight = constrainedSize.height - [self innerVertSide];
    if (innerHeight <= 0) {
        NSCAssert(0, @"constrainedSize太小了！");
    }
    
    CGFloat min = 1.f;
    CGFloat ah  = (innerHeight - fitHeight) / fillNodes.count;
    for (EUINode *node in fillNodes) {
        CGRect  node_r = EUIRectUndefine();
        CGFloat w = 0;
        CGFloat h = ah - EUIValue(node.margin.top) - EUIValue(node.margin.bottom);
        node_r.size.height = h;
        ///< 给1个像素的容错值，如果尺寸过小，无有效的fill高度，就给一个1-point占位。
        ///< 毕竟已经显示异常了
        h = MAX(min, h);
        if (h == min) {
            w =  min;
            [node setCacheFrame:node_r];
            continue;
        }
        
        EUIParseContext ctx = (EUIParseContext) {
            .step = (EUIParsedStepX | EUIParsedStepY | EUIParsedStepH),
            .recalculate = YES,
            .constraintSize = (CGSize) {constrainedSize.width - [self innerHorzSide], h}
        };
        [self.parser.wParser parse:node _:nil _:&ctx];
        w = ctx.frame.size.width;{
            node_r.size.width = w;
        }
        [node setCacheFrame:node_r];
        size.width = EUI_CLAMP(w, size.width, constrainedSize.width);
    }
    
    return size;
}

- (CGFloat)innerHorzSide {
    return EUIValue(self.padding.left) + EUIValue(self.padding.right);
}

- (CGFloat)innerVertSide {
    return EUIValue(self.padding.top) + EUIValue(self.padding.bottom);
}

#pragma mark - Private

- (void)parseY:(EUINode *)node _:(EUINode *)preNode _:(EUIParseContext *)context {
    EUIParsedStep *step = &(context->step);
    CGRect *frame = &(context->frame);
    CGRect preFrame = preNode ? preNode.cacheFrame : CGRectZero;
    if (preNode && CGRectEqualToRect(CGRectZero, preFrame)) {
        NSCAssert(0, @"EUIError : Layout:[%@] 在 Row 模板下的 Frame 计算异常", preNode);
    }
    CGFloat y = 0;
    if (preNode) {
        y = EUIValue(node.margin.top) + EUIValue(CGRectGetMaxY(preFrame)) + EUIValue(preNode.margin.bottom);
    } else {
        y = EUIValue(node.margin.top) + EUIValue(self.padding.top);
        if (!self.isHolder) {
            y += CGRectGetMinY(self.cacheFrame);
        }
    }
    frame -> origin.y = CGFloatPixelRound(y);
    *step |= EUIParsedStepY;
}

@end
