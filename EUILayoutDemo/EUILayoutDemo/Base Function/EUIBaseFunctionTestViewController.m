//
//  EUIBaseFunctionTestViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/11/5.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseFunctionTestViewController.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"

@interface EUIBaseFunctionTestViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIView *baseContainer;
@end

@implementation EUIBaseFunctionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackButton:EButton(@"Back", ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:NULL];
    })];
    
    self.baseContainer = [UIView new];
    self.baseContainer.frame = self.view.bounds;
    [self.view addSubview:self.baseContainer];
    
    UIButton *add = EButton(@"add", ^{ @strongify(self); [self addLayout];});
    UIButton *del = EButton(@"del", ^{ @strongify(self); [self delLayout];});
    
    UIView *pannelA = [UIView new];
    pannelA.tag = 11;
    EUITemplet *g = TColumn(add, del);
    [pannelA eui_lay:g];

    EUITemplet *one = TRow
    (
        pannelA
    );
    one.margin = EUIEdgeMake(10, 10, 10, 10);
    [self.baseContainer eui_layout:one];
}

- (void)addLayout {
    UIView *one = [self.view viewWithTag:11];
    one = self.baseContainer;
    [one eui_addLayout:TColumn(EText(@"1"),EText(@"2"))];
}

- (void)delLayout {
    UIView *one = [self.view viewWithTag:11];
    one = self.baseContainer;
    EUINode *node = [one eui_nodeAtIndex:3];
    if (node) {
        [one eui_removeLayout:node];
    }
}

@end
