//
//  UIView+EUILayout.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUILayouter.h"

typedef void (^EUIConfigurationBlock)(EUILayout *layout);

@interface UIView (EUILayout)

///< 获得当前视图的布局管理器，默认是空
@property (nonatomic, strong, readonly) EUILayouter *eui_layouter;

///< 创建布局管理器并绑定一个 delegate
- (void)eui_creatLayouterByDelegate:(__weak id)delegate;

#pragma mark -

///< 获得当前视图的布局 Node，该对象是懒加载创建
@property (nonatomic, strong, readonly) EUILayout *eui_layout;

- (void)eui_setLayout:(EUILayout *)layout;
- (void)eui_configure:(EUIConfigurationBlock)block;

@end
