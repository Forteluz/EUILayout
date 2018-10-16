//
//  UIView+EUILayout.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUILayout.h"

#pragma mark -

typedef void (^EUIConfigurationBlock)(EUINode *node);

#pragma mark -

@interface UIView (EUILayout)

///< 获得当前视图的布局管理器，LazyLoad
@property (nonatomic, strong, readonly) EUILayout *eui_layout;

///< 获得当前视图的布局 Node，LazyLoad
@property (nonatomic, strong, readonly) __kindof EUINode *eui_node;

/**
 创建布局管理器并绑定一个 delegate
 @param delegate 指定的代理
 */
- (void)eui_setDelegate:(__weak id <EUILayoutDelegate>)delegate;

/**
 Call layout update!
 */
- (void)eui_reload;

/**
 清空当前的模板,移除所有视图和对应的 Node
 */
- (void)eui_clean;

/**
 设置一个模板
 @param templet ：盛满视图的容器
 */
- (void)eui_update:(EUITemplet *)templet;

/**
 显示设置自己的布局对象
 @param node 一个布局对象
 */
- (void)eui_setNode:(EUINode *)node;

/**
 对自己的 EUILayout 布局对象进行配置
 @param block 并未 Copy，放心食用
 @return 将配置好的 layout 返回出来
 */
- (EUINode *)eui_configure:(EUIConfigurationBlock)block;


@end
