//
//  EUITestTopCard.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestTopCard.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"
///< Subviews
#import "EUITestUserNameView.h"

@interface EUITestTopCard()
@property (nonatomic, strong) UIView *avatar;
@property (nonatomic, strong) EUITestUserNameView *userName;
@property (nonatomic, strong) UIView *userInfo;
@property (nonatomic, strong) UIView *action;
@end
@implementation EUITestTopCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.avatar = EButton(@"😳", NULL);
        [self addSubview:self.avatar];
        self.userInfo = EButton(@"INFO", NULL);
        [self addSubview:self.userInfo];
        self.action = EButton(@"ACTION", NULL);
        [self addSubview:self.action];
        self.userName = [EUITestUserNameView new];
        [self addSubview:self.userName];
        self.eui_height = [EUITestTopCard height:nil];
    
        self.avatar.eui_size = CGSizeMake(60, 60);
        self.avatar.eui_gravity = EUIGravityCenter;
        self.action.eui_size = CGSizeMake(44, 44);
        self.action.eui_gravity = EUIGravityCenter;
    }
    return self;
}

- (void)updateWithModel:(id)model {
    
    [self.userName update:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    ///===============================================
    /// 模仿 Case ==> 0 : 正常 , 1 : 无右侧的 action
    ///===============================================
    int testCase = EUIRandom(0, 1);

    ///===============================================
    /// EUILayout
    ///===============================================
    EUITemplet *one = TColumn(self.avatar,
                              TRow(self.userName,
                                   self.userInfo)
                              );
    if (testCase == 0) {
        [one addLayout:self.action];
    }
    [self eui_lay:one];
    
    ///===============================================
    /// Frame
    ///===============================================
    /*
    self.avatar.frame = CGRectMake(0,
                                   (self.bounds.size.height - 60) * 0.5,
                                   60,
                                   60);
    if (testCase == 0) {
        self.userName.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10,
                                         0,
                                         self.bounds.size.width - 44 - self.avatar.bounds.size.width - 10,
                                         self.bounds.size.height / 2);
    } else {
        self.userName.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10,
                                         0,
                                         self.bounds.size.width - self.avatar.bounds.size.width - 10,
                                         self.bounds.size.height / 2);
    }
    if (testCase == 0) {
        self.userInfo.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10,
                                         CGRectGetMaxY(self.userName.frame),
                                         self.bounds.size.width - 44 - self.avatar.bounds.size.width,
                                         self.bounds.size.height / 2);
    } else {
        self.userInfo.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10,
                                         CGRectGetMaxY(self.userName.frame),
                                         self.bounds.size.width - self.avatar.bounds.size.width,
                                         self.bounds.size.height / 2);
    }
    if (testCase) {
        self.action.hidden = NO;
        self.action.frame = CGRectMake(self.bounds.size.width - 44,
                                       (self.bounds.size.height - 44) * 0.5,
                                       44,
                                       44);
    } else {
        self.action.hidden = YES;
    }
    */
}

+ (CGFloat)height:(id)object {
    return 82;
}

@end
