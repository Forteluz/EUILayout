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

typedef void (^EUIConfigurationBlock)(EUINode *node);

#pragma mark -

/*!
 *
 如何使用，从 Container 的视角，示例：
 ///< 布局一个模板
 [self eui_layout:TRow(view1, view2, view3, ...)];
 
 注意事项：
    1、EUILayout 布局不要和其他布局体系混用；
    2、EUILayout 默认处理了视图的加载和移除操作；
 */
@interface UIView (EUILayout)

#pragma mark - EUI Node Properties

/*!
 *  如果自己是容器，则返回容器的根模板，如果自己是子布局，则返回其父容器模板
 */
@property (nonatomic, readonly) __kindof EUITemplet *eui_templet;

///< 显式设置在模板中的 x 坐标
@property (nonatomic) CGFloat eui_x;

///< 显式设置在模板中的 y 坐标
@property (nonatomic) CGFloat eui_y;

///< 显式设置一个绝对宽度
@property (nonatomic) CGFloat eui_width;

///< 设置最大宽，当高度填充时会以该值为标准
@property (nonatomic) CGFloat eui_maxWidth;

///< 设置最小宽，当宽度压缩时会以该值为标准
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
 外边距，总用于相邻布局对象的间距关系，如果无相邻对象，该值设置无效
 @note 比如
     UIViewController *one;
     one.view.eui_margin = margin; ///< 该设置无效，因为 vc 的视图是根容器没有相对布局的对象
     …………
 */
@property (nonatomic, strong) EUIEdge *eui_margin;

/*!
 *  内边距，当 layout 作为 templet 容器时，该值才有意义，EUIEdge.Zero
 */
@property (nonatomic, strong) EUIEdge *eui_padding;

/*!
 *  layout 的唯一标示，默认是 nil（暂未实现）
 */
@property (nonatomic, copy) NSString *eui_uniqueID;

#pragma mark - Layout

/*!
 *  布局模板，并刷新视图
 *  自己会作为父视图自动 addSubview: 模板中的子视图
 *  @warning 每次 eui_layout： 时会自动移除未在模板中的子视图，如：
    1、[self eui_layout:TRow(viewA)]; ///< viewA 被添加；
    2、[self eui_layout:TRow(viewB)]; ///< viewB 被添加，viewA 做 removeFromSuperview；
 */
- (void)eui_layout:(EUITemplet *)templet;

/*!
 *  刷新，该方法会刷新整个模板布局
 */
- (void)eui_reload;

#pragma mark - 增删查改 Layout

/*!
 *  如果自己是容器，添加一个布局并刷新整个模板
 *  @warning 如果自己不是容器该方法不会工作
 */
- (void)eui_addLayout:(EUIObject)object;

/*!
 *  如果自己是容器，移除容器模板中的一个布局，并刷新模板
 *  @warning 如果自己不是容器该方法不会工作
 */
- (void)eui_removeLayout:(EUIObject)object;

/*!
 *  如果自己是容器，移除容器中模板上的所有布局
 *  @warning 如果自己不是容器该方法不会工作
 */
- (void)eui_removeAllLayouts;

/*!
 *  查询对应 index 的 layout; index 的范围是 [0 -- (count - 1)];
 *  @warning 只有容器视图才可以查询，否则返回 nil, 且 index 错误会返回 nil;
 *  @return 一个 layout 对象（或者 Templet 对象）
 */
- (__kindof EUINode *)eui_nodeAtIndex:(NSInteger)index;

/*!
 *  重新设置自己的 layout 布局对象
 */
- (void)eui_updateNode:(__kindof EUINode *)layout;

/**
 提供一个配置接口，主要用于结构化配置代码 ( for perty code if needed )
 */
- (EUINode *)eui_configure:(EUIConfigurationBlock)block;

#pragma mark -

///< 自己的 EUI 布局引擎（LazyLoad）
@property (nonatomic, strong, readonly) EUIEngine *eui_engine;

///< 自己的 EUI 布局描述对象（LazyLoad）
@property (nonatomic, strong, readonly) __kindof EUINode *eui_node;

@end
