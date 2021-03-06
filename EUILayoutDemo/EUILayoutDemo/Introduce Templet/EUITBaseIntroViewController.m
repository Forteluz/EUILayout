//
//  EUITBaseIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITBaseIntroViewController.h"
#import "EUITempletDebugginView.h"

@implementation EUITBaseIntroViewController {
    EUITempletDebugginView *_pannel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  在 TBase 模板中的，Node 只和模板产生约束，Node 之间互不影响；
     *  多用于处理比较动态的布局关系，如 Frame 或者 Masonry 指定布局
     */
    @weakify(self)
    UIButton *gravity = EButton(@"\n Gravity ：Tap Me ! \n", ^{
        @strongify(self)
        [self randomGravity];
    });
    gravity.eui_gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
    gravity.eui_sizeType = EUISizeTypeToFit;
    gravity.tag = 1;

    self.backButton.eui_height = 40;
    self.backButton.eui_margin.top  = 30;
    self.backButton.eui_margin.left = 10;
    
    UIView *a = EText(@"a");a.eui_height = 50;
    UIView *b = EText(@"b");b.eui_height = 50;
    UIView *c = EText(@"c");c.eui_height = 50;
    UIView *d = EText(@"d");d.eui_height = 50;

    UIView *grid = [UIView new];
    grid.eui_sizeType = EUISizeTypeToVertFit;
    [grid eui_layout:TRow(a,b,c,d)];
    
    [self.view eui_layout:TBase(gravity, self.backButton, grid)];

    /* 也可以使用比较鬼畜的结构
     ...
     EUITemplet *one = TBase
     (
        ///< 可以这样用，直接使用“eui_”属性
        ({
            self.backButton.eui_size = CGSizeMake(100, 40);
            self.backButton.eui_margin.top  = 30;
            self.backButton.eui_margin.left = 10;
            self.backButton;
        }),
        ///< 也可以使用 eui_configure：做配置，使用 block 可以很好的做代码的结构化
        [gravity eui_configure:^(EUINode *layout) {
            layout.gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
            layout.sizeType = EUISizeTypeToFit;
        }],
        sizeType
     );
     ...
     *
     */
}

#pragma mark - Gravity

- (void)randomGravity {
    int i = EUIRandom(1, 3);
    UIView *one = _pannel;
    EUINode *node = one.eui_node;
    switch (i) {
        case 1:{
            node.gravity = EUIGravityHorzCenter | EUIGravityVertCenter;
        } break;
        case 2:{
            node.gravity = EUIGravityHorzStart | EUIGravityVertCenter;
        } break;
        case 3:{
            node.gravity = EUIGravityHorzEnd | EUIGravityVertEnd;
        } break;
    }
    [self.view eui_reload];
}

@end
