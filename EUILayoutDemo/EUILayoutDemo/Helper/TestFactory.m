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
    [one setFont:[UIFont boldSystemFontOfSize:16]];
    [one setNumberOfLines:0];
    [one.layer setBorderWidth:1.f];
    [one.layer setBorderColor:UIColor.blackColor.CGColor];
    one.textColor = UIColor.whiteColor;
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
    [one setTitleColor:[UIColor colorWithWhite:0.8 alpha:0.8] forState:UIControlStateSelected];
    [one setTitleColor:[UIColor colorWithWhite:0.8 alpha:0.8] forState:UIControlStateHighlighted];
    [one.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [one.titleLabel setNumberOfLines:0];
    [one.layer setBorderWidth:1.f];
    [one.layer setBorderColor:UIColor.blackColor.CGColor];
    [one setBackgroundColor:EUIRandomColor];
    return one;
}
