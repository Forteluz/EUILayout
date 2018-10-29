//
//  EUITColumnIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITColumnIntroViewController.h"
#import "EUITempletDebugginView.h"
#import "EUILayoutKit.h"

@interface EUITColumnIntroViewController ()

@end

@implementation EUITColumnIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EUITempletDebugginView *debug1 = [EUITempletDebugginView new];
    EUITempletDebugginView *debug2 = [EUITempletDebugginView new];
    EUITempletDebugginView *debug3 = [EUITempletDebugginView new];
    
    EUITemplet *one = TColumn
    (
        [self.backButton eui_configure:^(EUILayout *node) {
            node.maxHeight = 80;
        }],
        debug1,
        debug2,
        debug3,
     );
    
    [self.view eui_lay:one];
}

@end
