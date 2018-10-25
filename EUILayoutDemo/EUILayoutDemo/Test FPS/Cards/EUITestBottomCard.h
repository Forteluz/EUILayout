//
//  EUITestBottomCard.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EUITestBottomCard : UIView
@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIView *messageView;
- (void)updateWithModel:(id)model;
+ (CGFloat)height:(id)object;
@end

