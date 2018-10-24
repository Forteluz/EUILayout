//
//  TSInfoBaseView.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/12.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSInfoBaseView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasIcon;
@property (nonatomic, copy) void (^actionBlock)(void);
@end

NS_ASSUME_NONNULL_END
