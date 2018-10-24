//
//  EUITestUserNameView.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestUserNameView.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"


@implementation EUITestUserNameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = EText(@"用戶名");
        self.nameLabel.eui_sizeType = EUISizeTypeToFit;
        self.nameLabel.eui_gravity = EUIGravityHorzStart | EUIGravityVertCenter;
        self.nameLabel.eui_margin.left = 10;
        self.nameLabel.eui_margin.right = 10;

        self.genderLabel = EText(@"🧔🏼");
        self.genderLabel.eui_sizeType = EUISizeTypeToFit;
        self.genderLabel.eui_gravity = EUIGravityHorzStart | EUIGravityVertCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self eui_layout:TColumn(self.nameLabel, self.genderLabel)];
}

@end
