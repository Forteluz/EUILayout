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
//    [self.view eui_reload];
    [self.view eui_update:[self templetWithLayout:nil]];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    EUITemplet *edgeT =
    TRow([self backBtn],
         EText(@"边距测试"),
//         TColumn(
//         [self button:@"“根模板”内边距测试" todo:1],
//         [self button:@"“边距测试模板”内边距距测试" todo:2],
//         [self button:@"“边距测试模板”外边距距测试" todo:3]
//                 ),
//         EText(@"测试")
         );

//    edgeT.margin.top = 20;
    return edgeT;
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
            EUITemplet *one = [root nodeAtIndex:1];
            [self updatePaddingWithNode:one];
        } break;
        case 3: {
            EUITemplet *one = [root nodeAtIndex:1];
            int i = EUIRandom(0, 2);
            EUINode *node = [one nodeAtIndex:i];
            [self updateMarginWithNode:node];
        }
    }
    [self.view eui_update:root];
}

- (UIButton *)button:(NSString *)title todo:(NSInteger)action {
//    @weakify(self);
    UIButton *one = EButton(title, ^{
//        @strongify(self);
//        [self todo:action];
    });
    return one;
}

@end
