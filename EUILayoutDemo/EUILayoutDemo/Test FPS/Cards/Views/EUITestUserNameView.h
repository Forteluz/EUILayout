//
//  EUITestUserNameView.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EUITestUserNameView : UIView
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *genderLabel;
- (void)update:(id)data;
@end

