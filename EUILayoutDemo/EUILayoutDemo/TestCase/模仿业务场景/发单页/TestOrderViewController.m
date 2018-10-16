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
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

#pragma mark -

///< 顶部订单信息模板
- (EUITemplet *)topOrderTemplet {
    EUITemplet *one =
        TRow(self.fromPOIView,
             self.toPOIView,
             TColumn(self.timeView),
             TColumn(self.pNumView, self.tipsView)
             );
    return one;
    
    return [TRow(self.fromPOIView,
                 self.toPOIView,
                 [TColumn(self.timeView) configure:^(EUINode *layout) {
        layout.sizeType = EUISizeTypeToVertFit;
    }],
                 [TColumn(self.pNumView, self.tipsView) configure:^(EUINode *layout) {
        layout.sizeType = EUISizeTypeToVertFit;
    }]
                 ) configure:^(EUINode *layout) {
        layout.padding = EUIEdgeMake(10, 10, 10, 10);
    }];
}

///< 底部价格区模板
- (EUITemplet *)bottomCardTemplet {
    EUITemplet *one =
    TRow(@"");
    return one;
}

- (EUITemplet *)templetWithLayout:(EUILayout *)layouter {
    EUITemplet *one =
        TRow([self backBtn],
             [self topOrderTemplet]
             );
    one.margin.top = 20;
    return one;
}

@end
