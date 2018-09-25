//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "EUIColumnTemplet.h"

#define _SETButton(_N_, _TITLE_)                                          \
     self.view##_N_ = [self creatButton];                                 \
     self.view##_N_.tag = _N_;                                            \
    [self.view##_N_ setTitle:_TITLE_ forState:UIControlStateNormal];


@interface ViewController() <EUILayouterDataSource>
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _SETButton(1, @"测试1");
    _SETButton(2, @"测试2");
    _SETButton(3, @"测试3");
    _SETButton(4, @"测试4");
    _SETButton(5, @"测试5");
    _SETButton(6, @"测试6");
    
    [self.view eui_creatLayouterByDelegate:self];
    [self.view.eui_layouter update];
}

#pragma mark - EUILayouterDataSource

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    return TColumn(self.view1,
                   self.view2,
                   self.view3,
                   self.view4,
                   self.view5,
                   self.view6).t_margin(20,0,0,0);
}

#pragma mark -

- (UIButton *)creatButton {
    UIButton *one = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [one setBackgroundColor:DCRandomColor];
    [one addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return one;
}

- (void)action:(UIButton *)button {
    NSInteger tag = button.tag;
    NSString *clsName = [@"TestViewController" stringByAppendingFormat:@"%ld",(long)tag];
    if (!NSClassFromString(clsName)) {
        return;
    }
    UIViewController *one = [NSClassFromString(clsName) new];
    [self presentViewController:one animated:YES completion:NULL];\
}

@end
