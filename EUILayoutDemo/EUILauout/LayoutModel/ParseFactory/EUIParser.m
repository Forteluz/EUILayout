//
//  EUIParser.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIParser.h"
#import "EUIXParser.h"
#import "EUIYParser.h"
#import "EUIWParser.h"
#import "EUIHParser.h"

@implementation EUIParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _xMan = [EUIXParser new];
        _yMan = [EUIYParser new];
        _wMan = [EUIWParser new];
        _hMan = [EUIHParser new];
    }
    return self;
}

- (void)parse:(EUINode *)node
            _:(EUINode *)preNode
            _:(EUICalculatStatus *)context
{
    if (self.parsingBlock) {
        self.parsingBlock(node, preNode, context);
        return;
    }
    
    NSInteger exceptions = 2;
    NSInteger loop = 0;
    do {
        if ((node.gravity & EUIGravityHorzEnd) || (node.gravity & EUIGravityHorzCenter)) {
            if (!(context->step & EPStepW)) {
                [self.wMan parse:node _:preNode _:context];
            }
            if (!(context->step & EPStepX)) {
                [self.xMan parse:node _:preNode _:context];
            }
        } else {
            if (!(context->step & EPStepX)) {
                [self.xMan parse:node _:preNode _:context];
            }
            if (!(context->step & EPStepW)) {
                [self.wMan parse:node _:preNode _:context];
            }
        }
        if ((node.gravity & EUIGravityVertEnd) || (node.gravity & EUIGravityVertCenter)) {
            if (!(context->step & EPStepH)) {
                [self.hMan parse:node _:preNode _:context];
            }
            if (!(context->step & EPStepY)) {
                [self.yMan parse:node _:preNode _:context];
            }
        } else {
            if (!(context->step & EPStepY)) {
                [self.yMan parse:node _:preNode _:context];
            }
            if (!(context->step & EPStepH)) {
                [self.hMan parse:node _:preNode _:context];
            }
        }
        loop ++;
        if (loop >= exceptions) {
            NSLog(@"捕捉异常计算!");
        }
    } while (!(loop <= exceptions) || (context->step & 0xFF) != EPStepFinished);
}

@end
