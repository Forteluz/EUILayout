//
//  EUITestBottomCard.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestBottomCard.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"

@implementation EUITestBottomCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.eui_height = [EUITestBottomCard height:nil];
        
        self.messageView = EText(@"含感谢费3元");
        self.actionView  = EButton(@"邀请同行", NULL);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.actionView.eui_size = CGSizeMake(68, 30);
    self.actionView.eui_gravity = EUIGravityVertCenter;
    
    [self eui_layout:TColumn(self.messageView, self.actionView)];
}

- (void)updateWithModel:(id)model {
    
}

+ (CGFloat)height:(id)object {
    return 50;
}

@end
