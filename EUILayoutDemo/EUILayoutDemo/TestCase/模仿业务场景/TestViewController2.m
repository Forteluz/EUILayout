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

- (void)dealloc {
    [self.view.eui_layout clean];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    UIButton *a = EButton(@"发单页", ^{
        @strongify(self);
        [self gotoVC:NSClassFromString(@"TestOrderViewController")];
    });
    UIButton *b = EButton(@"列表页", ^{
        @strongify(self);
        [self gotoVC:NSClassFromString(@"TestListViewController")];
    });
    NSArray *package = @[a, b];
    EUITemplet *one =
        TRow(self.backBtn,
             a,
             b
             );
    one.margin.top = 20;
    [self.view.eui_layout updateTemplet:one];
}

@end
