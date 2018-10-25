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
//RICO TODO: add guide view
@property (nonatomic, copy) NSString *guideView;
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
//    self.infoView.frame = CGRectMake(10, 10, 10, 10);
    self.infoView.backgroundColor = EUIRandomColor;
    self.infoView.eui_margin.top = 10;
    self.infoView.eui_margin.bottom = 10;
    self.infoView.eui_height = 50*4;
    self.infoView.eui_width = self.view.bounds.size.width - 10*2;
    
    UIButton *fromPOIBtn = EButton(@"北京-数字传媒大厦", ^{
        
    });
    UIButton *toPOIBtn = EButton(@"北京-地铁西二旗站A出口", ^{
        
    });
    
    UIButton *peopleNumBtn = EButton(@"乘车人数", ^{
        
    });
    
    UIButton *timeInputBtn = EButton(@"出发时间", ^{
        
    });
    
    UIButton *demandInputBtn = EButton(@"出行要求", ^{
        
    });
    
    UIButton *thanksFeeBtn = EButton(@"感谢费", ^{
        
    });
    
    EUIGridTemplet *grid = TGrid(
                                 peopleNumBtn,
                                 timeInputBtn,
                                 demandInputBtn,
                                 thanksFeeBtn
                                 );
    grid.columns = 2;
    
    EUITemplet *one = TRow(
        fromPOIBtn,
        toPOIBtn,
        grid
    );
    
    [self.infoView eui_layout:one];
}

- (void)configureBannerView {
    self.bannerView = [[UIView alloc] init];
    self.bannerView.backgroundColor = EUIRandomColor;
    self.bannerView.eui_height = 50;
    self.bannerView.eui_width = self.view.bounds.size.width - 20;
    self.bannerView.eui_margin.bottom = 10;
    
    UIButton *btn1 = EButton(@"顺风出行保障", ^{
        
    });
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton *btn2 = EButton(@"免费获赠保障120万意外险 24小时全国免费120救援", ^{
        
    });
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    EUITemplet *bannerViewTemplet = TRow(btn1, btn2);
    [self.bannerView eui_layout:bannerViewTemplet];
}

- (EUITemplet *)carpoolTemplet {
    UIButton *willingCarpool = EButton(@"愿意拼座", ^{
        
    });
    
    UIButton *discountBtn = EButton(@"拼成立减2.8元", ^{
        
    });
    
    UIButton *checkbox = EButton(@"✅️", ^{
        
    });
    EUITemplet *one = TColumn(
        willingCarpool,
        discountBtn,
        checkbox
    );
    
    one.height = 60;
    
    return one;
}

- (void)configurePriceView {
    self.priceView = [[UIView alloc] init];
    self.priceView.backgroundColor = EUIRandomColor;
    self.priceView.eui_height = 200;
    self.priceView.eui_width = self.view.bounds.size.width - 20;
    
    EUITemplet *carpoolTemplet = [self carpoolTemplet];
    
    UIButton *price = EButton(@"12元", ^{
        
    });
    
    EUITemplet *priceTemplet = TRow(
        carpoolTemplet,
        price
    );
    
    [self.priceView eui_layout:priceTemplet];
}

- (void)configureConfirmView {
    self.confirmView = [[UIView alloc] init];
    self.confirmView.backgroundColor = EUIRandomColor;
    self.confirmView.frame = CGRectMake(10, 0, self.view.bounds.size.width-20, 60);
    self.confirmView.eui_margin.bottom = 20;
    self.confirmView.eui_height = 60;
    self.confirmView.eui_margin.top = 15;
    
    UIButton *btn1 = EButton(@"确认发布", ^{
        
    });
    EUITemplet *one = TRow(btn1);
    [self.confirmView eui_layout:one];
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
     self.priceView,
     self.confirmView
     );
    
    below.height = 300;
    below.gravity = EUIGravityEnd;
    return below;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBackBtn];
    [self configureInfoView];
    [self configureBannerView];
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
    
    [self.view eui_layout:one];
}

@end
