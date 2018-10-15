//
//  TestTRowViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTRowViewController.h"

@interface TestTRowViewController ()
@end

@implementation TestTRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view eui_reload];
    
    EUITemplet *one = nil;
    one.height = 44;
    [self.view eui_reload];
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    EUITemplet *edgeT =
//    TRow([self lable:@"边距测试"],
         TColumn([self button:@"“根模板”内边距测试" tag:1],
//                 [self button:@"“边距测试模板”内边距距测试" tag:2],
//                 [self button:@"“边距测试模板”外边距距测试" tag:3]
                 );
//         );
    
    return edgeT;
}

- (UILabel *)lable:(NSString *)title {
    UILabel *one = [UILabel new];
    one.text = title;
    one.textAlignment = NSTextAlignmentCenter;
    one.backgroundColor = EUIRandomColor;
    return one;
}

- (UIButton *)button:(NSString *)title tag:(NSInteger)tag {
    UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
    [one setTitle:title forState:UIControlStateNormal];
    [one.titleLabel setNumberOfLines:10];
    [one setTag:tag];
    [one addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [one setBackgroundColor:EUIRandomColor];
    return one;
}

- (void)buttonAction:(UIButton *)button {
    EUITemplet *root = self.view.eui_layout.rootTemplet;
    switch (button.tag) {
        case 1: {
            [self testPaddingWithTemplet:root];
        }  break;
        case 2: {
            EUITemplet *one = [root nodeAtIndex:0];
            [self testPaddingWithTemplet:one];
        } break;
    }
    [self.view eui_update:root];
}

#pragma mark -

- (void)testPaddingWithTemplet:(EUITemplet *)templet {
    EUIEdge *padding = EUIEdge.edgeZero;
    if (templet.padding.left == 0) {
        padding = EUIEdgeMake(10, 10, 10, 10);
    }
    [templet configure:^(EUINode *layout) {
        layout.padding = padding;
    }];
}


@end
