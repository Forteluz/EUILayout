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

    @weakify(self);
    UIButton *a = EButton(@"发单页", ^{
        @strongify(self); EUIGoto(self, @"TestOrderViewController");
    });
    UIButton *b = EButton(@"列表页", ^{
        @strongify(self); EUIGoto(self, @"TestListViewController");
    });
    EUITemplet *one =
        TRow(self.backBtn,
             a,
             b
             );
    one.margin.top = 20;
    [self.view.eui_engine layoutTemplet:one];
}

@end
