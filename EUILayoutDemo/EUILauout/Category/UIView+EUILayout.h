//
//  UIView+EUILayout.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUILayouter.h"

#pragma mark -

typedef void (^EUIConfigurationBlock)(EUILayout *layout);

#pragma mark -

@interface UIView (EUILayout)

///< 获得当前视图的布局管理器，默认是空
@property (nonatomic, strong, readonly) EUILayouter *eui_layouter;

///< 获得当前视图的布局 Node，该对象是懒加载创建
@property (nonatomic, strong, readonly) EUILayout *eui_layout;

/**
 创建布局管理器并绑定一个 delegate
 @param delegate 指定的代理
 */
- (void)eui_creatLayouterByDelegate:(__weak id <EUILayouterDataSource>)delegate;

/**
 将自己作为容器，设置一个布局模板，并更新模板指定的视图
 @param templet 一个模板
 */
- (void)eui_updates:(EUITemplet *)templet;

/**
 显示设置自己的布局对象
 @param layout 一个布局对象
 */
- (void)eui_setLayout:(EUILayout *)layout;

/**
 对自己的 EUILayout 布局对象进行配置
 @param block 并未 Copy，放心食用
 @return 将配置好的 layout 返回出来
 */
- (EUILayout *)eui_configure:(EUIConfigurationBlock)block;

@end
