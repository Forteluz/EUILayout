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

    
//    UIView *view = [UIView new];
//    view.tag = 1;
//    view.backgroundColor = [UIColor redColor];
//    view.frame = CGRectMake(5, 60, 200, 400);
//    [self.view addSubview:view];
//
//    UIView *view2 = [UIView new];
//    view2.tag = 2;
//    view2.frame = CGRectMake(210, 60, 200, 200);
//    view2.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:view2];
//
//    self.view1.eui_node.margin = EUIEdgeMake(10, 10, 10, 10);
//
//    EUITemplet *row_1_1 = TColumn(self.view2, self.view3);
//    EUITemplet *row_1 = TColumn(self.view1,
//                                row_1_1,
//                                TRow(self.view4,self.view5)
//                                );
//    [view eui_update:row_1];
}

- (void)change {
    self.view1.eui_node.margin = EUIEdgeMake(10, 10, 10, 10);
    
    EUITemplet *row_1_1 = TColumn(self.view2, self.view3);
    EUITemplet *row_1 = TColumn(self.view1,
                                row_1_1,
                                TRow(self.view4,self.view5)
                                );
    
    static int i = 1;
    if (i % 2 == 0) {
        UIView *view = [self.view viewWithTag:1];
        [view eui_update:row_1];
    } else {
        UIView *view = [self.view viewWithTag:2];
        [view eui_update:row_1];
    }
    i ++;
}

- (void)setupSubviews {
    @weakify(self);
    if (!_view1) {
        self.view1 = EButton(@"v1:布局模板介绍", ^{
            @strongify(self); EUIGoto(self, @"TestViewController1")
        });
    }
    if (!_view2) {
        self.view2 = EButton(@"v2:模仿业务场景布局", ^{
            @strongify(self); EUIGoto(self, @"TestViewController2")
        });
    }
    if (!_view3) {
        self.view3 = EButton(@"v3:Tap Me!", ^{
            @strongify(self);
            [self testRandomPosition];
        });
    }
    if (!_view4) {
        self.view4 = EButton(@"v4:清除所有模板（2秒后重加载）", ^{
            @strongify(self);
            [self cleanTemplet];
        });
    }
    if (!_view5) {
        self.view5 = EButton(@"v5:测试父视图", ^{
            @strongify(self);
            [self change];
        });
    }
    if (!_view6) {
        self.view6 = EButton(@"v6:测试6", ^{
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
    self.view1.eui_node.margin = EUIEdgeMake(10, 10, 10, 10);
    self.view4.eui_node.margin = EUIEdgeMake(10, 10, 10, 10);
    EUITemplet *one =
        TRow(self.view1,
             self.view2,
             TColumn(self.view3, self.view4),
             TColumn(self.view5, self.view6)
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
