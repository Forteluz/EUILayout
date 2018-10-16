//
//  TestTEasyViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTEasyViewController.h"

@interface TestTEasyViewController () <EUILayoutDelegate>

@end

@implementation TestTEasyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

- (void)setupSubviews {
    self.view1 = EButton(@"测试1", ^{
    });
    self.view2 = EButton(@"测试2", ^{
    });
    self.view3 = EButton(@"测试3", ^{
    });
    self.view4 = EButton(@"测试4", ^{
    });
    self.view5 = EButton(@"测试5", ^{
    });
    self.view6 = EButton(@"测试6", ^{
    });
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    [self.backBtn eui_configure:^(EUINode *layout) {
        layout.margin = EUIEdgeMake(20, 20, 0, 0);
        layout.width = 50;
        layout.sizeType = EUISizeTypeToFit;
        layout.zPosition = EUILayoutZPostionHigh;
    }];
    [self.view1 eui_configure:^(EUINode *layout) {
        layout.margin = EUIEdgeMake(10, 10, 10, 10);
        layout.zPosition = EUILayoutZPostionLow;
    }];
    [self.view2 eui_configure:^(EUINode *layout) {
        layout.margin = EUIEdgeMake(60, 20, 20, 0);
        layout.width = 50;
    }];
    [self.view3 eui_configure:^(EUINode *layout) {
        layout.margin.top   = self.view2.eui_node.margin.top;
        layout.margin.left  = 80;
        layout.margin.right = 20;
        layout.height = 50;
    }];
    [self.view4 eui_configure:^(EUINode *layout) {
        layout.gravity = EUIGravityVertEnd | EUIGravityHorzEnd;
        layout.zPosition = EUILayoutZPostionNormal - 1;
        layout.sizeType = EUISizeTypeToFit;
    }];
    
    ///< 模板嵌套
    return TBase(self.view1,self.view2, self.view3, self.view4, self.backBtn);
}

- (EUITemplet *)testTempViews {
    UIView *a = ({
        UIView *one = [UIView new];
        one.backgroundColor = EUIRandomColor;
        one.eui_node.sizeType = EUISizeTypeToVertFit | EUISizeTypeToHorzFill;
        one.eui_node.margin.bottom = one.eui_node.margin.top = 10;
        one.eui_node.maxHeight = 40;
        one;
    });
    UIView *b = ({
        UIButton *one = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        one.backgroundColor = EUIRandomColor;
        one.eui_node.sizeType = EUISizeTypeToVertFill | EUISizeTypeToHorzFit;
        one.eui_node.maxHeight = 60;
        one.eui_node.maxWidth = 100;
        one.eui_node.gravity = EUIGravityVertCenter;
        [one addTarget:self action:@selector(updateLayout) forControlEvents:UIControlEventTouchUpInside];
        one;
    });
    
    return TRow([self.view1 eui_configure:^(EUINode *layout) {
                    
                }],
                self.view2);
    
    return TBase(
                 [self.backBtn eui_configure:^(EUINode *layout) {
                    layout.margin.top = 20;
                 }],
                 [TBase(a) configure:^(EUINode *layout) {
                    layout.margin.top = 60;
                    layout.maxHeight = 100;
                 }],
                 [TBase(b) configure:^(EUINode *layout) {
                    layout.margin.top = 60 + 100 + 20 + 20;
                    layout.maxHeight = 130;
                 }]
                );
}

@end
