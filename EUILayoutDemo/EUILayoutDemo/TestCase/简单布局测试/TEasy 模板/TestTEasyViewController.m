//
//  TestTEasyViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTEasyViewController.h"

@interface TestTEasyViewController () <EUILayouterDataSource>

@end

@implementation TestTEasyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _SETButton(1, @"视图1");
    _SETButton(2, @"视图2");
    _SETButton(3, @"视图3");
    _SETButton(4, @"视图4");
    _SETButton(5, @"视图5");
    _SETButton(6, @"视图6");
    
    [self.view eui_creatLayouterByDelegate:self];
    [self.view.eui_layouter update];
}

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    [self.backBtn eui_configure:^(EUILayout *layout) {
        layout.margin = EUIEdgeMake(20, 20, 0, 0);
        layout.width = 50;
        layout.sizeType = EUILayoutSizeToFit;
        layout.zPosition = EUILayoutZPostionHigh;
    }];
    [self.view1 eui_configure:^(EUILayout *layout) {
        layout.margin = EUIEdgeMake(10, 10, 10, 10);
        layout.zPosition = EUILayoutZPostionLow;
    }];
    [self.view2 eui_configure:^(EUILayout *layout) {
        layout.margin = EUIEdgeMake(60, 20, 20, 0);
        layout.width = 50;
    }];
    [self.view3 eui_configure:^(EUILayout *layout) {
        layout.margin.top   = self.view2.eui_layout.margin.top;
        layout.margin.left  = 80;
        layout.margin.right = 20;
        layout.height = 50;
    }];
    [self.view4 eui_configure:^(EUILayout *layout) {
        layout.hAlign = EUILayoutAlignEnd;
        layout.vAlign = EUILayoutAlignEnd;
        layout.zPosition = EUILayoutZPostionNormal - 1;
        layout.sizeType = EUILayoutSizeToFit;
    }];
    
//    return TBase(self.backBtn, self.view1, self.view2, self.view3, self.view4);
    
    ///< 模板嵌套
    return TBase(self.view1,
                 [TBase(self.view2, self.view3, self.view4) configure:^(EUILayout *layout) {
                    layout.height = 200;
                    layout.margin.left = layout.margin.right = 20;
                    layout.margin.top  = 30;
                 }]);
}

- (void)action:(UIButton *)button {
    switch (button.tag) {
        
    }
    [self.view.eui_layouter update];
}

- (EUITemplet *)absoultBaseTemplet {
    return TBase(self.view1);
}


@end
