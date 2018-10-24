//
//  EUITestTopCard.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EUITestTopCard : UIView
@property (nonatomic, strong) UIView *avatar;
@property (nonatomic, strong) UIView *userName;
@property (nonatomic, strong) UIView *userInfo;
@property (nonatomic, strong) UIView *action;

+ (CGFloat)height:(id)object;

@end

