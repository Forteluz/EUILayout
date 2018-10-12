//
//  TestTRowViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTRowViewController.h"

@interface TestTRowViewController ()
@end

@implementation TestTRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _SETButton(1, @"插入 TRow Layout");
    _SETButton(2, @"按钮2");
    _SETButton(3, @"按钮3");
    _SETButton(4, @"");
    _SETButton(5, @"");
    _SETButton(6, @"");
    
    [self updateLayout];
}

- (void)action:(UIButton *)button {
    switch (button.tag) {
        case 1: [self insertLayout]; break;
    }
}

- (void)insertLayout {
    UIButton *button = [TestFactory creatButton:@"插入的 button" tag:100];
    [self.view.eui_layouter.rootTemplet addNode:button];
}

- (EUITemplet *)templetWithLayouter:(EUILayouter *)layouter {
    return TRow(self.backBtn,
                self.view1,
                self.view2
                );
}


@end
