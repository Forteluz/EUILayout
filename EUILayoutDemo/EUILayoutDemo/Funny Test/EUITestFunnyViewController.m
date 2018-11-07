//
//  EUITestFunnyViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/26.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestFunnyViewController.h"
#import "EUILayoutKit.h"
#import "TestFactory.h"
#import "Masonry.h"

@interface EUITestFunnyViewController ()

@end

@implementation EUITestFunnyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    @weakify(self)
    UIButton *back = EButton(@"BACK", ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
    
    UIView *one = EText(@"one"); one.eui_height = 40;
    UIView *two = EText(@"two"); two.eui_height = 60;
    UIView *container = [UIView new];
    [container setBackgroundColor:EUIRandomColor];
    [container setEui_sizeType:EUISizeTypeToVertFit];
    [container eui_layout:TRow(one, two)];
    [self.view eui_layout:TRow(
                            container,
                            back,
                            )];
    
}

@end
