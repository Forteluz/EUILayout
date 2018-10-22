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

#pragma mark - EUI Node Properties

///< layout 所依赖的模板
@property (nonatomic, weak) __kindof EUINode *eui_templet;

///< 显式设置在模板中的 x 坐标
@property (nonatomic) CGFloat eui_x;

///< 显式设置在模板中的 y 坐标
@property (nonatomic) CGFloat eui_y;

///< 显式设置一个绝对宽度
@property (nonatomic) CGFloat eui_width;

///< 设置一个最大的绝对宽，当需要计算宽度时会使用该值作为边界
@property (nonatomic) CGFloat eui_maxWidth;
@property (nonatomic) CGFloat eui_minWidth;

///< 显示设置其绝对高
@property (nonatomic) CGFloat eui_height;

///< 设置一个最大的绝对高，当需要计算高度时会使用该值作为边界
@property (nonatomic) CGFloat eui_maxHeight;
@property (nonatomic) CGFloat eui_minHeight;

///< 显示设置其在模板中的位置
@property (nonatomic) CGPoint eui_origin;

///< 显示设置其绝对的大小
@property (nonatomic) CGSize eui_size;

///< 显示设置其绝对值的位置和大小
@property (nonatomic) CGRect eui_frame;

///< 设置尺寸计算类型，default EUISizeTypeToFill
@property (nonatomic) EUISizeType eui_sizeType;

///< 可指定布局在横向和纵向的相对位置（相对于templet考虑），默认是 EUIGravityHorzStart | EUIGravityVertStart
@property (nonatomic) EUIGravity eui_gravity;

///< 外边距，总用于相邻布局对象的间距关系
@property (nonatomic, strong) EUIEdge *eui_margin;

///< 内边距，当 layout 作为 templet 容器时，该值才有意义，作用于 SubLayouts
@property (nonatomic, strong) EUIEdge *eui_padding;

///< 可设置一个唯一ID，便于快速查找
@property (nonatomic, copy) NSString *eui_uniqueID;

#pragma mark - Access

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

#pragma mark -

///< 获得当前视图的布局管理器，LazyLoad
@property (nonatomic, strong, readonly) EUILayout *eui_layout;

///< 获得当前视图的布局 Node，LazyLoad
@property (nonatomic, strong, readonly) __kindof EUINode *eui_node;

@end
