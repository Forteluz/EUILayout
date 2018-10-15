//
//  BaseViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "BaseTestViewController.h"

@interface BaseTestViewController ()
@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _SETButton(1, @"视图1");
    _SETButton(2, @"视图2");
    _SETButton(3, @"视图3");
    _SETButton(4, @"视图4");
    _SETButton(5, @"视图5");
    _SETButton(6, @"视图6");
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:({
        UIButton *one = [TestFactory creatButton:@"返回" tag:1];
        [one addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [one setBounds:(CGRect){0, 0, 100, 40}];
        [one.eui_node setSizeType:EUISizeTypeToFit];
        self.backBtn = one;
        self.backBtn;
    })];
    
    [self.view eui_setDelegate:self];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)action:(UIButton *)button {}

- (void)gotoVC:(Class)clas {
    UIViewController *one = [clas new];
    [self presentViewController:one animated:YES completion:NULL];
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    return TRow(self.backBtn, self.view1);
}

- (void)updateLayout {
    [self.view.eui_layout update];
}

@end
