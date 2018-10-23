//
//  ViewController1.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestViewController1.h"

@interface TestViewController1 ()

@end

@implementation TestViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self.view eui_layout:TRow(self.backBtn,
                               self.view1,
                               self.view2,
                               self.view3
                               )];
}

- (void)setupSubviews {
    @weakify(self);
    self.view1 = EButton(@"基本布局模板：TEasy", ^{
        @strongify(self);
        EUIGoto(self, @"TestTEasyViewController");
    });
    self.view2 = EButton(@"行布局模板：TRow", ^{
        @strongify(self);
        EUIGoto(self, @"TestTRowViewController")
    });
    self.view3 = EButton(@"列布局模板：TColumn", ^{
    });
    self.view4 = EButton(@"测试4", ^{
    });
    self.view5 = EButton(@"测试5", ^{
    });
    self.view6 = EButton(@"测试6", ^{
    });
}

#pragma mark - EUILayouterDataSource


@end
