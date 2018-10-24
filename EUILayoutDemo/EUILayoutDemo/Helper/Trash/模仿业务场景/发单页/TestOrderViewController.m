//
//  TestOrderViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestOrderViewController.h"
#import "TSPOIInfoView.h"
#import "TSTimeInfoView.h"
#import "TSPNumInfoView.h"
#import "TSTipsInfoView.h"

@interface TestOrderViewController ()
@property (nonatomic, strong) TSPOIInfoView *fromPOIView;
@property (nonatomic, strong) TSPOIInfoView *toPOIView;
@property (nonatomic, strong) TSTimeInfoView *timeView;
@property (nonatomic, strong) TSPNumInfoView *pNumView;
@property (nonatomic, strong) TSTipsInfoView *tipsView;
@end

@implementation TestOrderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fromPOIView = [TSPOIInfoView new];
        self.toPOIView = [TSPOIInfoView new];
        self.timeView = [TSTimeInfoView new];
        self.pNumView = [TSPNumInfoView new];
        self.tipsView = [TSTipsInfoView new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view eui_setDelegate:self];
//    [self.view eui_reload];
    [self setupSubviews];
}

#pragma mark -

- (void)setupSubviews {
    ///< 顶部发单信息区
    CGRect r = CGRectMake(10, 60, self.view.frame.size.width - 20, 200);
    UIView *view = [[UIView alloc] initWithFrame:r];
    
    UIView *line = EText(@"→");
    line.eui_layout.sizeType = EUISizeTypeToFit;
    line.eui_layout.gravity  = EUIGravityVertCenter | EUIGravityHorzCenter;
    
    [view eui_layout:TRow(EButton(@"起点", NULL),
                          EButton(@"终点", NULL),
                          TColumn(EButton(@"开始时间", NULL), line, EButton(@"结束时间", NULL)),
                          TColumn(EButton(@"乘车人数", NULL), EButton(@"出行要求", NULL))
                          )];
    [self.view addSubview:view];
    
    ///< 底部发单区
    
}

@end
