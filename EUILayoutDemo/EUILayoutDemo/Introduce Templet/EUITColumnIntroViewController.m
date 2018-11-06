//
//  EUITColumnIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITColumnIntroViewController.h"
#import "EUITempletDebugginView.h"
#import "EUILayoutKit.h"

@interface EUITColumnIntroViewController ()

@end

@implementation EUITColumnIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.eui_maxHeight = 80;
    
    @weakify(self);
    UIView *a = EButton(@"a", ^{@strongify(self) [self a];});
    UIView *b = EButton(@"b", ^{@strongify(self) [self b];});
    UIView *c = EButton(@"c", ^{@strongify(self) [self c];});
    UIView *d = EButton(@"d", ^{@strongify(self) [self d];});
    UIView *e = EButton(@"e", ^{@strongify(self) [self e];});
    
    UIView *one = [UIView new];
    [one setBackgroundColor:EUIRandomColor];
    [one eui_lay:TRow(a, b)];
    
    UIView *two = [UIView new];
    [two setBackgroundColor:EUIRandomColor];
    [two eui_lay:TRow(c, d)];
    
    [self.view eui_lay:TColumn(
                               self.backButton,
                               one,
                               e
                               )];
    [self.view eui_layoutSubviews];
}

- (void)a {
    [self.view setEui_padding:EUIEdgeMake(10, 10, 10, 10)];
    [self.view eui_reload];
}

- (void)b {
    [self.view setEui_margin:EUIEdgeMake(10, 10, 10, 10)];
    [self.view eui_reload];
}

- (void)c {}

- (void)d {}

- (void)e {}

@end
