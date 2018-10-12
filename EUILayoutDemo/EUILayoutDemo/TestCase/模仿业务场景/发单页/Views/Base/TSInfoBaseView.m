//
//  TSInfoBaseView.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/12.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TSInfoBaseView.h"
#import "EUILayoutKit.h"

@interface TSInfoBaseView()
@property (nonatomic, strong) UIButton *button;
@end
@implementation TSInfoBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DCRandomColor;
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [self setHasIcon:YES];
        [self eui_configure:^(EUILayout *layout) {
            layout.maxHeight = 50;
            layout.sizeType = EUISizeTypeToFit;
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _button.frame = self.bounds;
}

- (void)action {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    [_button setTitle:title forState:UIControlStateNormal];
}

- (void)setHasIcon:(BOOL)hasIcon {
    if (_hasIcon != hasIcon) {
        _hasIcon  = hasIcon;
        [_button setImage:(hasIcon ? [UIImage imageNamed:@"icon_detail_g"] : nil)
                 forState:UIControlStateNormal];
        [self setNeedsLayout];
    }
}

@end
