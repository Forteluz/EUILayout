//
//  EUITGridIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITGridIntroViewController.h"
#import "EUITempletDebugginView.h"
#import "EUILayoutKit.h"

@interface EUITGridIntroViewController ()

@end

@implementation EUITGridIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    EUITempletDebugginView *debug1 = [EUITempletDebugginView new];
//    EUITempletDebugginView *debug2 = [EUITempletDebugginView new];
//    EUITempletDebugginView *debug3 = [EUITempletDebugginView new];
//
//    debug1.eui_margin = EUIEdgeMake(10, 10, 10, 10);
//    debug2.eui_margin = EUIEdgeMake(10, 10, 10, 10);
//    debug3.eui_margin = EUIEdgeMake(10, 10, 10, 10);
//
    EUITemplet *one = TGrid
    (
        [self.backButton eui_configure:^(EUINode *node) {
            node.maxHeight = 80;
            node.margin = EUIEdgeMake(10, 10, 10, 10);
        }],
        EText(@"1"),
        EText(@"2"),
        EText(@"3"),
        EText(@"4"),
     );
    [self.view eui_layout:one];
}

@end
