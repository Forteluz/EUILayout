//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "TestFactory.h"

@interface ViewController() <EUILayouterDataSource>
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _SETButton(1, @"布局模板介绍");
    _SETButton(2, @"模仿业务场景布局");
    _SETButton(3, @"测试3");
    _SETButton(4, @"测试4");
    _SETButton(5, @"测试5");
    _SETButton(6, @"测试6");
    
    EUITemplet *one = nil;
    [one addNode:nil];
    
    [self.view eui_creatLayouterByDelegate:self];
    [self.view.eui_layouter update];
}

#pragma mark - EUILayouterDataSource

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    [self.view1 eui_configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToHorzFill | EUISizeTypeToVertFit;
    }];
    [self.view4 eui_configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToHorzFill | EUISizeTypeToVertFit;
        layout.gravity = EUIGravityVertCenter;
    }];
    [self.view6 eui_configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToHorzFit | EUISizeTypeToVertFit;
    }];
    EUITemplet *one = TRow(self.view1,
                           self.view2,
                           self.view3,
                           TColumn(self.view4, self.view5, self.view6));
    [one configure:^(EUILayout *layout) {
        layout.sizeType = EUISizeTypeToHorzFill | EUISizeTypeToVertFit;
        layout.margin.top = 20;
    }];
    return one;
}

#pragma mark - Action

- (void)action:(UIButton *)button {
    NSInteger tag = button.tag;
    NSString *clsName = [@"TestViewController" stringByAppendingFormat:@"%ld",(long)tag];
    if (!NSClassFromString(clsName)) {
        return;
    }
    UIViewController *one = [NSClassFromString(clsName) new];
    [self presentViewController:one animated:YES completion:NULL];
}

@end
