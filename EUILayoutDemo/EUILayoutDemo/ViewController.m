//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "TestFactory.h"

@interface ViewController() <EUILayoutDelegate>
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

- (void)setupSubviews {
    @weakify(self);
    if (!_view1) {
        self.view1 = EButton(@"布局模板介绍", ^{
            @strongify(self);
            UIViewController *one = [NSClassFromString(@"TestViewController1") new];
            [self presentViewController:one animated:YES completion:NULL];
        });
    }
    if (!_view2) {
        self.view2 = EButton(@"模仿业务场景布局", ^{
            @strongify(self);
            UIViewController *one = [NSClassFromString(@"TestViewController2") new];
            [self presentViewController:one animated:YES completion:NULL];
        });
    }
    if (!_view3) {
        self.view3 = EButton(@"Tap Me!", ^{
            @strongify(self);
            [self testRandomPosition];
        });
    }
    if (!_view4) {
        self.view4 = EButton(@"清除所有模板（2秒后重加载）", ^{
            @strongify(self);
            [self cleanTemplet];
        });
    }
    if (!_view5) {
        self.view5 = EButton(@"测试5", ^{
            @strongify(self);
        });
    }
    if (!_view6) {
        self.view6 = EButton(@"测试6", ^{
            @strongify(self);
        });
    }
}

#pragma mark - EUILayouterDataSource

- (EUITemplet *)templetWithLayout:(EUILayout *)layout {
    ///< ---- config ----
    [self.view1 eui_configure:^(EUINode *node) {
        node.sizeType = EUISizeTypeToHorzFill | EUISizeTypeToVertFit;
    }];
    ///< ----------------
    self.view3.eui_node.sizeType = EUISizeTypeToHorzFit | EUISizeTypeToVertFill;
    self.view3.eui_node.gravity  = EUIGravityHorzEnd;
    ///< ----------------
    [self.view4 eui_configure:^(EUINode *node) {
        node.sizeType = EUISizeTypeToHorzFill | EUISizeTypeToVertFit;
        node.gravity = EUIGravityVertCenter;
    }];
    [self.view6 eui_configure:^(EUINode *node) {
        node.sizeType = EUISizeTypeToFit;
    }];
    ///< ----------------
    EUITemplet *one =
        TRow(self.view1,
             self.view2,
             self.view3,
             TColumn(self.view4, self.view5, self.view6)
             );
    one.margin.top = 20;
    return one;
}

#pragma mark - Action

- (void)action:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag == 3) {
        [self testRandomPosition];
        return;
    }
    if (tag == 4) {
        [self cleanTemplet];
        return;
    }
    NSString *clsName = [@"TestViewController" stringByAppendingFormat:@"%ld",(long)tag];
    if (!NSClassFromString(clsName)) {
        return;
    }
    UIViewController *one = [NSClassFromString(clsName) new];
    [self presentViewController:one animated:YES completion:NULL];
}

- (void)testRandomPosition {
    EUITemplet *one = nil;
    static int num = 0;
    static int max = 3;
    if (num > max) {
        num = 0;
    }
    NSLog(@"testRandomPosition:%d",num);
    switch (num) {
        case 0: {
            one = TRow(self.view3,
                       self.view2,
                       self.view1,
                       TColumn(self.view4, self.view5, self.view6)
                       );
        } break;
        case 1: {
            one = TRow(TColumn(self.view3, self.view2, self.view1),
                       TColumn(self.view4, self.view5, self.view6)
                       );
        } break;
        case 2: {
            one = TRow(self.view6,
                       self.view3,
                       self.view2,
                       self.view5,
                       self.view1,
                       self.view4,
                       );
        } break;
        default:{
             [self.view eui_reload];
        } break;
    }
    num++;
    if ( one ) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.view eui_update:one];
        }];
    }
}

- (void)cleanTemplet {
    ///< Test Release...
    [self setView1:nil];
    [self setView2:nil];
    [self.view eui_clean];

    EUIAfter(dispatch_get_main_queue(), 2, ^{
        [self setupSubviews];
        [self.view eui_setDelegate:self];
        [self.view eui_reload];
    });
}

@end
