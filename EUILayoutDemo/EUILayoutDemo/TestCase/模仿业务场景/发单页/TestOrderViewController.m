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
    [self updateLayout];
}

#pragma mark -

- (EUITemplet *)orderInputTemplet {
    return TRow(           [TColumn(self.timeView) configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToVertFit;
    }],
                );
    return TRow(self.fromPOIView,
                self.toPOIView,
                [TColumn(self.timeView) configure:^(EUILayout *layout) {
                    layout.sizeType = EUISizeTypeToVertFit;
    }],
                [TColumn(self.pNumView, self.tipsView) configure:^(EUILayout *layout) {
                    layout.sizeType = EUISizeTypeToVertFit;
    }]
                );
}

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    EUITemplet *one = TRow(
                           [TColumn(self.timeView) configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToVertFit;
    }],
                           );
    
    [one configure:^(EUILayout *layout) {
        layout.margin.top = 40;
        layout.sizeType = EUISizeTypeToVertFit;
    }];
    return one;
}

@end
