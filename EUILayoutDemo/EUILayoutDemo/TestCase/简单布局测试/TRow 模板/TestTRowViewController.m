//
//  TestTRowViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTRowViewController.h"
#import "TestLabel.h"

@interface TestTRowViewController ()
@end

@implementation TestTRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    NSArray *cloumn = @[
                        [self button:@"Root padding 测试" todo:1],
                        [self button:@"Column padding 测试" todo:2],
                        [self button:@"Node margin 测试" todo:3]
                        ];
    EUITemplet *one = TRow(self.backBtn,
                           EText(@"Just title"),
                           TColumn(cloumn) /*支持塞数组*/,
                           EText(@"Just title")
                           );
    one.margin.top = 20;
    return one;
}

#pragma mark -

- (void)updatePaddingWithNode:(EUINode *)node {
    EUIEdge *padding = EUIEdge.edgeZero;
    if (node.padding.left == 0) {
        padding = EUIEdgeMake(10, 10, 10, 10);
    }
    node.padding = padding;
}

- (void)updateMarginWithNode:(EUINode *)node {
    EUIEdge *margin = EUIEdge.edgeZero;
    if (node.margin.left == 0) {
        margin = EUIEdgeMake(20, 20, 20, 20);
    }
    node.margin = margin;
}

#pragma mark -

- (UILabel *)lable:(NSString *)title {
    TestLabel *one = [TestLabel new];
    one.text = title;
    one.textAlignment = NSTextAlignmentCenter;
    one.backgroundColor = EUIRandomColor;
    return one;
}

- (void)todo:(NSInteger)action {
    EUITemplet *root = self.view.eui_layout.rootTemplet;
    switch (action) {
        case 1: {
            [self updatePaddingWithNode:root];
        }  break;
        case 2: {
            EUITemplet *one = [root nodeAtIndex:2];
            [self updatePaddingWithNode:one];
        } break;
        case 3: {
            EUITemplet *one = [root nodeAtIndex:2];
            int i = EUIRandom(0, 2);
            EUINode *node = [one nodeAtIndex:i];
            [self updateMarginWithNode:node];
        }
    }
    [self.view eui_update:root];
}

- (UIButton *)button:(NSString *)title todo:(NSInteger)action {
    @weakify(self);
    UIButton *one = EButton(title, ^{
        @strongify(self);
        [self todo:action];
    });
    return one;
}

@end
