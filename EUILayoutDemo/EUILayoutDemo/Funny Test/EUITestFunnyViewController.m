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
#import "Masonry.h"

@interface EUITestFunnyViewController ()

@end

@implementation EUITestFunnyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self)
    UIButton *back = EButton(@"BACK", ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
    
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
    
    UIView *one = EText(@"1");
    one.eui_width = self.view.bounds.size.width * 2 / 3;
    [one eui_reload];
    
    UIView *two = EText(@"s");
    UIView *tre = EText(@"d");
    
    NSArray *arr = @[one, two, tre];
    
    UIView *container= [UIView new];
    container.frame = CGRectMake(10, 10, 100, 100);
    [container eui_lay:TRow(EText(@"c1"),EText(@"c2"))];
    
    [self.view eui_lay:TRow(
                            back,
//                             container,
//                             EText(@"1"),
//                             EText(@"2"),
//                             EText(@"3"),
//                             EText(@"4"),
//                             EText(@"5"),
                             arr,
                             )];
//    EUIAfter(dispatch_get_main_queue(), 1, ^{
//        [UIView animateWithDuration:0.2 animations:^{
//            [self.view eui_lay:TRow(back,
//                                    one,
//                                    TColumn(two,tre),
//                                    )];
//
//            ///<
//        }];
//    });
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
