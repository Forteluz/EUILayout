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
        self.eui_height = [EUITestTopCard height:nil];
        
        self.avatar = EButton(@"😳", NULL);

        self.userName = [EUITestUserNameView new];
        
        self.userInfo = EButton(@"INFO", NULL);
        self.action = EButton(@"ACTION", NULL);

        self.avatar.eui_size = CGSizeMake(60, 60);
        self.avatar.eui_gravity = EUIGravityCenter;
        self.action.eui_size = CGSizeMake(44, 44);
        self.action.eui_gravity = EUIGravityCenter;
    }
    return self;
}

- (void)updateWithModel:(id)model {
    static NSArray *avatars = nil;
    static NSArray *infos = nil;
    
    [self.userName update:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    EUITemplet *one = TColumn(self.avatar, TRow(self.userName,
                                                self.userInfo)
                              );
    
    ///< 模仿 Case ==> 0 : 正常 , 1 : 无右侧的 action
    int testCase = EUIRandom(0, 1);
    if (testCase == 0) {
        [one addLayout:self.action];
    }
    [self eui_layout:one];
}

+ (CGFloat)height:(id)object {
    return 82;
}

@end
