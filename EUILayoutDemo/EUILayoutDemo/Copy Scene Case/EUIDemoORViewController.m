//
//  EUIDemoORViewController.m
//  EUILayoutDemo
//
//  Created by yxj on 2018/10/24.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUIDemoORViewController.h"

@interface EUIDemoORViewController ()

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UIView *guideView;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UIView *confirmView;

@end

@implementation EUIDemoORViewController

- (void)configureBackBtn {
    [self.backButton eui_configure:^(EUILayout *node) {
        node.maxHeight = 80;
    }];
}

- (void)configureInfoView {
    self.infoView = [[UIView alloc] init];
    self.infoView.backgroundColor = EUIRandomColor;
    self.infoView.eui_margin.top = 10;
    self.infoView.eui_margin.bottom = 10;
    self.infoView.eui_height = 50*4;
    self.infoView.eui_width = self.view.bounds.size.width - 10*2;
    
    UIButton *fromPOIBtn = EButton(@"北京-数字传媒大厦", nil);
    UIButton *toPOIBtn = EButton(@"北京-地铁西二旗站A出口", nil);
    UIButton *peopleNumBtn = EButton(@"乘车人数", nil);
    UIButton *timeInputBtn = EButton(@"出发时间", nil);
    UIButton *demandInputBtn = EButton(@"出行要求", nil);
    UIButton *thanksFeeBtn = EButton(@"感谢费", nil);

    EUITemplet *g = TGrid(peopleNumBtn, timeInputBtn,
                          demandInputBtn, thanksFeeBtn
                          )
                    .config(^(EUIGridTemplet *one) {
                        one.columns = 2;
                    });
    
    EUITemplet *one = TRow(fromPOIBtn,
                           toPOIBtn,
                           g
                           );
    
    [self.infoView eui_lay:one];
}

- (void)configureBannerView {
    self.bannerView = [[UIView alloc] init];
    self.bannerView.backgroundColor = EUIRandomColor;
    self.bannerView.eui_height = 50;
    self.bannerView.eui_width = self.view.bounds.size.width - 20;
    self.bannerView.eui_margin.bottom = 10;
    
    UIButton *btn1 = EButton(@"顺风出行保障", nil);
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton *btn2 = EButton(@"免费获赠保障120万意外险 24小时全国免费120救援",nil);
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    EUITemplet *bannerViewTemplet = TRow(btn1, btn2);
    [self.bannerView eui_lay:bannerViewTemplet];
}

- (EUITemplet *)carpoolTemplet {
    UIButton *willingCarpool = EButton(@"愿意拼座", nil);
    UIButton *discountBtn = EButton(@"拼成立减2.8元",nil);
    UIButton *checkbox = EButton(@"✅️", nil);
    EUITemplet *one = TColumn(
        willingCarpool,
        discountBtn,
        checkbox
    );
    
    one.height = 60;
    
    return one;
}

- (void)configureGuideView {
    self.guideView = [UIView new];
    self.guideView.eui_x = -10;
    self.guideView.eui_width = self.view.bounds.size.width;
    self.guideView.eui_height = 100;
    self.guideView.backgroundColor = [UIColor redColor];
    self.guideView.eui_margin.bottom = 5;
    
    UIButton *btn = EButton(@"我是新手引导", nil);
    
    EUITemplet *one = TRow(btn);
    [self.guideView eui_lay:one];
}

- (void)configurePriceView {
    self.priceView = [[UIView alloc] init];
    self.priceView.backgroundColor = EUIRandomColor;
    self.priceView.eui_height = 200;
    self.priceView.eui_width = self.view.bounds.size.width - 20;
    
    EUITemplet *carpoolTemplet = [self carpoolTemplet];
    UIButton *price = EButton(@"12元", nil);
    
    EUITemplet *priceTemplet = TRow(
        carpoolTemplet,
        price
    );
    
    [self.priceView eui_lay:priceTemplet];
}

- (void)configureConfirmView {
    self.confirmView = [[UIView alloc] init];
    self.confirmView.backgroundColor = EUIRandomColor;
    self.confirmView.eui_margin.bottom = 20;
    self.confirmView.eui_margin.top = 15;
    self.confirmView.eui_size = CGSizeMake(self.view.bounds.size.width - 20, 60);
    
    UIButton *btn1 = EButton(@"确认发布", nil);
    [self.confirmView eui_lay:TRow(btn1)];
}

- (EUITemplet *)aboveTemplet {
    EUITemplet *above = TRow
        (
            self.infoView,
            self.bannerView,
        );
    above.height = 400;
    above.gravity = EUIGravityStart;
    above.margin.top = 80+10;
    return above;
}

- (EUITemplet *)belowTemplet {
    EUITemplet *below = TRow
        (
            self.guideView,
            self.priceView,
            self.confirmView
        );
    below.height = 300 + 100;
    below.gravity = EUIGravityEnd;
    return below;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBackBtn];
    [self configureInfoView];
    [self configureBannerView];
    
    [self configureGuideView];
    [self configurePriceView];
    [self configureConfirmView];
    
    EUITemplet *above = [self aboveTemplet];
    EUITemplet *below = [self belowTemplet];
    
    EUITemplet *one = TBase
        (
            self.backButton,
            above,
            below
        );
    one.padding.left = 10;
    one.padding.right = 10;
    
    [self.view eui_lay:one];
}

@end
