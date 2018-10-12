//
//  TestBusinessViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/12.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestViewController2.h"
#import "EUILayoutKit.h"
#import "TestFactory.h"

@interface TestViewController2 ()

@end

@implementation TestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray <NSString *> *list = @[@"发单页",
                                   @"列表页"];
    
    NSMutableArray *one = @[].mutableCopy;
    [one addObject:self.backBtn];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [TestFactory creatButton:obj tag:idx];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [one addObject:btn];
    }];
    
    [self.view.eui_layouter updateTemplet:TRow(one)];
}

- (void)action:(UIButton *)button {
    switch (button.tag) {
        case 0:[self gotoVC:NSClassFromString(@"TestOrderViewController")];
            break;
        case 1:[self gotoVC:NSClassFromString(@"TestListViewController")];
            break;
    }
}


@end
