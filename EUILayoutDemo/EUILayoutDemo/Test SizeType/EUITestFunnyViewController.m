//
//  EUITestFunnyViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/26.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestFunnyViewController.h"
#import "EUILayoutKit.h"
#import "TestFactory.h"

@interface EUITestFunnyViewController ()

@end

@implementation EUITestFunnyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *bannerView = [UIView new];
//    bannerView.backgroundColor = [UIColor redColor];
//    bannerView.eui_sizeType = EUISizeTypeToVertFit;
//
//    UIButton *btn1 = EButton(@"顺风出行保障", NULL);
//    btn1.eui_height = 20;
//    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//    UIButton *btn2 = EButton(@"免费获赠保障120万意外险 24小时全国免费120救援", NULL);
//    btn2.eui_height = 40;
//    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//    [bannerView.eui_margin setTop:20];
//    [bannerView eui_lay:TRow(btn1, btn2)];

    ///===============================================
    /// 随意测试
    ///===============================================
    [self.view eui_lay:TRow(EText(@"1"),EText(@"1"),EText(@"1"),EText(@"1"),EText(@"1"),EText(@"1"),)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
