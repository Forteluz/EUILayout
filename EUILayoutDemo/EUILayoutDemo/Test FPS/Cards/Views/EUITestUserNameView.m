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
        self.backgroundColor = [UIColor blueColor];
        self.nameLabel = EText(@"用戶名");
        self.nameLabel.eui_sizeType = EUISizeTypeToHorzFit;
        self.nameLabel.eui_gravity = EUIGravityHorzStart | EUIGravityVertCenter;
        self.nameLabel.eui_margin.left = 10;
        self.nameLabel.eui_margin.right = 10;
        self.nameLabel.eui_maxWidth = 200;

        self.genderLabel = EText(@"🧔🏼");
        self.genderLabel.eui_sizeType = EUISizeTypeToFit;
        self.genderLabel.eui_gravity = EUIGravityHorzStart | EUIGravityVertCenter;
    }
    return self;
}

- (void)update:(id)data {
    static NSArray *userNames = nil;
    if (userNames == nil) {
        userNames = @[@"特别长的用户名，有多长呢，大概有几十个字那么长吧，总之一行肯定是显示不下的",
                      @"溪大大", @"Lxvii", @"李晓雅", @"随便的用户名"];
    }
    int i = EUIRandom(0, (int)(userNames.count - 1));
    self.nameLabel.text = userNames[i];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    EUITemplet *templet = TColumn(self.nameLabel,
                                  self.genderLabel,
                                  );
    int i = EUIRandom(1, 2);
    if (i == 2) {
        UILabel *one = EText(@"|🧔🏼-🧔🏼|");
        [templet addNode:one];
    }
    [self eui_layout:templet];
}

@end
