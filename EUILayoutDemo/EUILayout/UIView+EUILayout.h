//
//  UIView+EUIEngine.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIEngine.h"
#import "EUITemplet.h"

#pragma mark -

typedef void (^EUIConfigurationBlock)(EUILayout *node);

#pragma mark -

@interface UIView (EUILayout)

#pragma mark - EUI Node Properties

///< 自己的模板容器
@property (nonatomic, weak) __kindof EUITemplet *eui_templet;

///< 显式设置在模板中的 x 坐标
@property (nonatomic) CGFloat eui_x;

///< 显式设置在模板中的 y 坐标
@property (nonatomic) CGFloat eui_y;

///< 显式设置一个绝对宽度
@property (nonatomic) CGFloat eui_width;

///< 设置最大宽，当高度填充时会以该值为标准
@property (nonatomic) CGFloat eui_maxWidth;

///< 设置最小宽，当宽度收缩时会以该值为标准
@property (nonatomic) CGFloat eui_minWidth;

///< 显示设置其绝对高
@property (nonatomic) CGFloat eui_height;

///< 设置最大高，当高度填充时会以该值为标准
@property (nonatomic) CGFloat eui_maxHeight;

///< 设置最小高，当高度收缩时会以该值为标准
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

/**
 外边距，总用于相邻布局对象的间距关系
 */
@property (nonatomic, strong) EUIEdge *eui_margin;

/**
 内边距，当 layout 作为 templet 容器时，该值才有意义，EUIEdge.Zero
 */
@property (nonatomic, strong) EUIEdge *eui_padding;

/**
 layout 的唯一标示，默认是 nil（暂未实现）
 */
@property (nonatomic, copy) NSString *eui_uniqueID;

#pragma mark - Access

/**
 布局一个模板
 */
- (void)eui_layout:(EUITemplet *)templet;

/**
 自动刷新当前模板
 */
- (void)eui_reload;

/**
 移除所有的模板
 */
- (void)eui_cleanUp;

/**
 重新设置自己的 layout 布局对象
 */
- (void)eui_setNode:(EUILayout *)node;

/**
 提供一个配置接口，主要用于结构化配置代码 ( for perty code if needed )
 */
- (EUILayout *)eui_configure:(EUIConfigurationBlock)block;

/**
 返回根模板上的视图
 */
- (UIView *)eui_viewWithTag:(NSInteger)tag;

#pragma mark -

///< 自己的 EUI 布局引擎（LazyLoad）
@property (nonatomic, strong, readonly) EUIEngine *eui_engine;

///< 自己的 EUI 布局描述对象（LazyLoad）
@property (nonatomic, strong, readonly) __kindof EUILayout *eui_layout;

@end
