//
//  EUILayoutEdge.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/29.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIEdge.h"

@implementation EUIEdge

+ (instancetype)edgeWithInsets:(UIEdgeInsets)insts {
    EUIEdge *one = [self.class new];
    one.left = insts.left;
    one.top = insts.top;
    one.bottom = insts.bottom;
    one.right = insts.right;
    return one;
}

@end

@implementation EUILayoutMargin
@end

@implementation EUILayoutPadding
@end
