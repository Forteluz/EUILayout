//
//  BaseViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "BaseTestViewController.h"
#import "EUILayoutMetamacros.h"

@interface BaseTestViewController ()
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:({
        UIButton *one = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [one addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [one setTitle:@"返回" forState: UIControlStateNormal];
        [one setFrame:CGRectMake(10, 20, 100, 100)];
        [one setBackgroundColor:DCRandomColor];
        self.backBtn = one;
        self.backBtn;
    })];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
