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
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    EUITemplet *edgeT =
    TRow([self lable:@"title:边距测试"],
         TColumn([self button:@"“根模板”内边距测试" tag:1],
                 [self button:@"“边距测试模板”内边距距测试" tag:2],
                 [self button:@"“边距测试模板”外边距距测试" tag:3]
                 ),
         [self lable:@"测试顺序"],
         );
    
    return edgeT;
}

- (void)buttonAction:(UIButton *)button {
    EUITemplet *root = self.view.eui_layout.rootTemplet;
    switch (button.tag) {
        case 1: {
            [self updatePaddingWithNode:root];
        }  break;
        case 2: {
            EUITemplet *one = [root nodeAtIndex:1];
            [self updatePaddingWithNode:one];
        } break;
        case 3: {
            EUITemplet *one = [root nodeAtIndex:1];
            EUINode *node = [one nodeAtIndex:1];
            [self updateMarginWithNode:node];
        }
    }
    [self.view eui_update:root];
}

#pragma mark -

- (void)updatePaddingWithNode:(EUINode *)node {
    EUIEdge *padding = EUIEdge.edgeZero;
    if (node.padding.left == 0) {
        padding = EUIEdgeMake(10, 10, 10, 10);
    }
    [node configure:^(EUINode *layout) {
        layout.padding = padding;
    }];
}

- (void)updateMarginWithNode:(EUINode *)node {
    EUIEdge *margin = EUIEdge.edgeZero;
    if (node.margin.left == 0) {
        margin = EUIEdgeMake(10, 10, 10, 10);
    }
    [node configure:^(EUINode *layout) {
        layout.margin = margin;
    }];
}

#pragma mark -

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

@end
