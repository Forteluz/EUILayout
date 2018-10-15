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
    
    _SETButton(1, @"基本布局模板：TEasy");
    _SETButton(2, @"行布局模板：TRow");
    _SETButton(3, @"列布局模板：TColumn");
    _SETButton(4, @"测试4");
    _SETButton(5, @"测试5");
    _SETButton(6, @"测试6");
    
    [self.view eui_setDelegate:self];
    [self.view.eui_layout update];
}

- (void)action:(UIButton *)button {
    NSString *clsName = nil;
    switch (button.tag) {
        case 1:clsName = @"TestTEasyViewController"; break;
        case 2:clsName = @"TestTRowViewController";  break;
    }
    if (!NSClassFromString(clsName)) {
        return;
    }
    UIViewController *one = [NSClassFromString(clsName) new];
    [self presentViewController:one animated:YES completion:NULL];
}

#pragma mark - EUILayouterDataSource

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    return TRow(self.backBtn,
                self.view1,
                self.view2,
                self.view3
                );
}

@end
