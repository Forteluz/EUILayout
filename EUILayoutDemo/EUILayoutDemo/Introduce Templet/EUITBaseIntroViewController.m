//
//  EUITBaseIntroViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITBaseIntroViewController.h"

@interface EUITBaseIntroViewController () <EUILayoutDelegate>

@end

@implementation EUITBaseIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  在 TBase 模板中的，Node 只和模板产生约束，Node 之间互不影响；
     *  多用于处理比较动态的布局关系，如 Frame 或者 Masonry 指定布局
     */
    
    ///< 模板支持临时变量
    @weakify(self)
    UIButton *button1 = EButton(@"Gravity 助手", ^{
        @strongify(self)
        [self randomGravity];
    });
    button1.tag = 1;
    
    ///< 可以这样结构化代码
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
        [button1 eui_configure:^(EUINode *node) {
            node.gravity  = EUIGravityHorzCenter | EUIGravityVertCenter;
            node.sizeType = EUISizeTypeToFit;
        }],
    );
    
    [self.view eui_update:one];
    
    /* 也可以这样
     ...
     self.backButton.eui_size = CGSizeMake(100, 40);
     self.backButton.eui_margin.top  = 30;
     self.backButton.eui_margin.left = 10;
     ...
     [self.view eui_update:TBase(self.backButton, button1)];
     *
     */
}

#pragma mark - EUILayoutDelegate

- (EUITemplet *)templetWithLayout:(EUILayout *)layout {
    UIView *button = [self.view viewWithTag:1];

    ///< 模板的参数包不允许塞空，可以塞个空字符串
    return TBase(self.backButton,
                 button ?: @""
                 );
}

#pragma mark -

- (void)randomGravity {
    int i = EUIRandom(1, 3);
    UIView *button = [self gravityButton];
    EUINode *node = button.eui_node;
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
    ///< 使用代理的方式 update
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

- (UIView *)gravityButton {
    /**
     *  1.可以使用 index 的方式寻找模板中的 node
     */
    EUINode *node = [self.view.eui_templet nodeAtIndex:1];

    /**
     *  2.可以使用 唯一标识 UniqueID 的方式寻找模板中的 node
     */
    if (node == nil) {
        node = [self.view.eui_templet nodeWithUniqueID:@"gravityButton"];
    }
    
    return node.view;
}

@end
