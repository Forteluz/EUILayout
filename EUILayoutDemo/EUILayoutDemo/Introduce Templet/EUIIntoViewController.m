//
//  EUIIntoViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIIntoViewController.h"
#import "EUILayoutMacro.h"

@interface EUIIntoViewController ()

@end

@implementation EUIIntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setBackButton:EButton(@"Back", ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:NULL];
    })];
}

- (void)dealloc {
    NSLog(@"dealloc :%@",self);
}

@end
