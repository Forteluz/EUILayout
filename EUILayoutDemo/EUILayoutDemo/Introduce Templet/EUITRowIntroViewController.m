//
//  EUITRowIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITRowIntroViewController.h"
#import "EUITempletDebugginView.h"
#import "EUILayoutKit.h"

@implementation EUITRowIntroViewController {
    UIView *_baseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *base = [UIView new];
    base.tag = 1;
    base.frame = self.view.bounds;
    base.backgroundColor = [UIColor redColor];
    [self.view addSubview:base];
    _baseView = base;
    
    self.backButton.eui_maxHeight = 80;

    @weakify(self);
    UIView *a = EButton(@"a", ^{@strongify(self) [self a];});
    a.eui_margin = EUIEdgeMake(10, 10, 10, 10);
    
    UIView *b = EButton(@"b", ^{@strongify(self) [self b];});
    UIView *c = EButton(@"c", ^{@strongify(self) [self c];});
    UIView *d = EButton(@"d", ^{@strongify(self) [self d];});
    UIView *e = EButton(@"e", ^{@strongify(self) [self e];});
    
    UIView *one = [UIView new];
    [one setBackgroundColor:EUIRandomColor];
    [one setEui_margin:EUIEdgeMake(10, 10, 10, 10)];
    [one setEui_padding:EUIEdgeMake(10, 10, 10, 10)];
    [one eui_lay:TRow(a, b)];
    
    UIView *two = [UIView new];
    [two setBackgroundColor:EUIRandomColor];
    [two setEui_margin:EUIEdgeMake(10, 10, 10, 10)];
    [two setEui_padding:EUIEdgeMake(10, 10, 10, 10)];
    [two eui_lay:TRow(c, d)];

    ///< 因为Base 没有父 templet，所以 margin 是无效的
    [base setEui_margin:EUIEdgeMake(10, 10, 10, 10)];
    [base eui_lay:TRow(
                       self.backButton,
                       one,
                       two,
                       e,
                       )];
    [base eui_layoutSubviews];
}

- (void)a {
    EUIEdge *padding = _baseView.eui_padding;
    if (padding.left == 0) {
        padding = EUIEdgeMake(10, 10, 10, 10);
    } else {
        padding = EUIEdge.zero;
    }
    [_baseView setEui_padding:padding];
    [_baseView eui_reload];
}

- (void)b {
    EUIEdge *edge = _baseView.eui_margin;
    if (edge.left == 0) {
        edge = EUIEdgeMake(10, 10, 10, 10);
    } else {
        edge = EUIEdge.zero;
    }
    [_baseView setEui_margin:edge];
    [_baseView eui_reload];
}

- (void)c {}

- (void)d {}

- (void)e {}

@end
