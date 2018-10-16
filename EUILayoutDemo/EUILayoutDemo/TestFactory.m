//
//  TestFactory.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestFactory.h"
#import "TestLabel.h"
#import "TestButton.h"
#import "EUILayoutKit.h"

UILabel * EText(NSString *text) {
    TestLabel *one = [TestLabel new];
    one.text = text;
    one.textColor = EUIRandomColor;
    one.backgroundColor = EUIRandomColor;
    one.textAlignment = NSTextAlignmentCenter;
    return one;
}

UIButton * EButton(NSString *title, dispatch_block_t block) {
    TestButton *one = [TestButton buttonWithType:UIButtonTypeCustom];
    [one setAction:^(UIButton * _Nonnull one) {
        !block ?: block();
    }];
    [one setTitle:title forState:UIControlStateNormal];
    [one setTitleColor:EUIRandomColor forState:UIControlStateNormal];
    [one setTitleColor:EUIRandomColor forState:UIControlStateSelected];
    [one setTitleColor:EUIRandomColor forState:UIControlStateHighlighted];
    [one.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [one.titleLabel setNumberOfLines:0];
    [one setBackgroundColor:EUIRandomColor];
    return one;
}
