//
//  TestFactory.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestFactory.h"
#import "EUILayoutKit.h"

@implementation TestFactory

+ (UIButton *)creatButton:(NSString *)title
                      tag:(NSInteger)tag
{
    UIButton *one = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [one setBackgroundColor:EUIRandomColor];
    [one setTitle:title forState:UIControlStateNormal];
    [one setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [one setTag:tag];
    [one.layer setShadowColor:[UIColor colorWithWhite:0.1 alpha:0.08].CGColor];
    [one.layer setShadowOffset:CGSizeMake(4, 4)];
    [one.layer setShadowRadius:8];
    [one setClipsToBounds:YES];
    [one.titleLabel setFont:[UIFont systemFontOfSize:16.]];
    return one;
}

@end
