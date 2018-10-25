//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "TestFactory.h"

@interface ViewController()
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *bannerView = [[UIView alloc] init];
    bannerView.backgroundColor = EUIRandomColor;
    bannerView.eui_sizeType = EUISizeTypeToVertFit;
//    bannerView.eui_height = 50;
//    bannerView.eui_width = self.view.bounds.size.width - 20;
    bannerView.eui_margin.bottom = 10;
    
    UIButton *btn1 = EButton(@"顺风出行保障", ^{
        
    });
    btn1.eui_height = 20;
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIButton *btn2 = EButton(@"免费获赠保障120万意外险 24小时全国免费120救援", ^{
        
    });
    btn2.eui_height = 20;
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    EUITemplet *bannerViewTemplet = TRow(btn1, btn2);
    [bannerView eui_layout:bannerViewTemplet];

    @weakify(self);
    EUITemplet *templet =
        TRow(
//             bannerView,
             EButton(@"Template Introduction", ^{ @strongify(self); [self templateIntroduction];}),
             EButton(@"Copy Scene Case", ^{ @strongify(self); [self copySceneCase];}),
             EButton(@"Test FPS 😁", ^{ @strongify(self); [self testFPS];}),
             );
    templet.padding = EUIEdgeMake(10, 10, 10, 10);
    templet.margin.top = 40;
    
    [self.view eui_layout:templet];
}

#pragma mark - Action

- (void)templateIntroduction {
    @weakify(self);
    EUIGridTemplet *one =
        TGrid(EButton(@"TBase",   ^{@strongify(self) [self introduceTBase];}),
              EButton(@"TGrid",   ^{@strongify(self) [self introduceTGrid];}),
              EButton(@"TRow" ,   ^{@strongify(self) [self introduceTRow];}),
              EButton(@"TColumn", ^{@strongify(self) [self introduceTColumn];}),
              EButton(@"Close",   ^{@strongify(self) [self introduceColse];}));
    one.columns = 4;
    
    EUILayout *node = [self.view.eui_templet layoutAtIndex:0];
    [node.view eui_layout:one];
}

- (void)copySceneCase {
    EUIGoto(self, @"EUIDemoORViewController");
}

- (void)testFPS {
    EUIGoto(self, @"EUITestFPSViewController");
}

#pragma mark - Introduce Templet

- (void)introduceTBase {
    EUIGoto(self, @"EUITBaseIntroViewController");
}

- (void)introduceTGrid {
    EUIGoto(self, @"EUITGridIntroViewController");
}

- (void)introduceTRow {
    EUIGoto(self, @"EUITRowIntroViewController");
}

- (void)introduceTColumn {
    EUIGoto(self, @"EUITColumnIntroViewController");
}

- (void)introduceColse {
    EUITemplet *templet = [self.view.eui_templet layoutAtIndex:0];
    [templet.view eui_cleanUp];
}

@end
