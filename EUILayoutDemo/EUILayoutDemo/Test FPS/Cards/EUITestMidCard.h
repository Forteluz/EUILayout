//
//  EUITestMidCard.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EUITestMidCard : UIView
@property (nonatomic, strong) UIView *icon;
@property (nonatomic, strong) UIView *time;
@property (nonatomic, strong) UIView *from;
@property (nonatomic, strong) UIView *to;
@property (nonatomic, strong) UIView *price;


+ (CGFloat)height:(id)object;
@end

NS_ASSUME_NONNULL_END
