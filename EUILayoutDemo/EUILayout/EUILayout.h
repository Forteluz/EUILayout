//
//  EUILayout.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUILayoutMacro.h"
#import "EUIUtilities.h"
#import "EUIEdge.h"

#pragma mark -

typedef NS_OPTIONS(NSUInteger, EUIGravity) {
    EUIGravityHorzStart  = 1 << 1,  ///< 水平居左
    EUIGravityHorzCenter = 1 << 2,  ///< 水平居中
    EUIGravityHorzEnd    = 1 << 3,  ///< 水平居右
    EUIGravityVertStart  = 1 << 4,  ///< 垂直居左
    EUIGravityVertCenter = 1 << 5,  ///< 垂直居中
    EUIGravityVertEnd    = 1 << 6,  ///< 垂直居右
    
    ///===============================================
    /// default EUIGravityStart
    ///===============================================
    EUIGravityStart      = EUIGravityHorzStart  | EUIGravityVertStart,
    EUIGravityCenter     = EUIGravityVertCenter | EUIGravityHorzCenter,
    EUIGravityEnd        = EUIGravityVertEnd    | EUIGravityHorzEnd,
};

typedef NS_OPTIONS(NSUInteger, EUISizeType) {
    ///< 不设置，计算时会以 EUISizeTypeToFill 处理
    EUISizeTypeNone = 0,

    ///===========================================================
    /// 水平或者垂直方向做 Fit 逻辑；计算时通过 view 的 sizeThatFits:
    /// 方法获取对应的 fit 大小进行布局；
    ///===========================================================
    EUISizeTypeToHorzFit = 1 << 7,
    EUISizeTypeToVertFit = 1 << 8,
    EUISizeTypeToFit = (EUISizeTypeToHorzFit | EUISizeTypeToVertFit),
    
    ///===========================================================
    /// 水平或者垂直方向做 Fill 填充处理；会自动填充到合适的大小；
    /// 默认是 EUISizeTypeToFill
    ///===========================================================
    EUISizeTypeToHorzFill = (EUIGravityHorzStart | EUIGravityHorzEnd),
    EUISizeTypeToVertFill = (EUIGravityVertStart | EUIGravityVertEnd),
    EUISizeTypeToFill = (EUISizeTypeToHorzFill | EUISizeTypeToVertFill),
};

typedef NS_ENUM(NSInteger, EUILayoutZPostion) {
    EUILayoutZPostionDefault = 1,    ///< Default
    EUILayoutZPostionLow     = 100,
    EUILayoutZPostionNormal  = 1000,
    EUILayoutZPostionHigh    = 10000,
};

#pragma mark -

UIKIT_STATIC_INLINE EUIEdge *EUIEdgeMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return [EUIEdge edgeWithInsets:(UIEdgeInsets) {
        top, left, bottom, right
    }];
}

#pragma mark -

///< 只支持 UIView 、EUILayout 、EUITemplet 、NSArray、[NSNull null]
typedef id EUIObject;

#pragma mark -

@interface EUILayout : NSObject

///< layout 所依赖的模板
@property (nonatomic, weak) __kindof EUILayout *templet;

///< layout 负责布局的视图对象
@property (nonatomic, strong) UIView *view;

///< 显式设置在模板中的 x 坐标
@property (nonatomic) CGFloat x;

///< 显式设置在模板中的 y 坐标
@property (nonatomic) CGFloat y;

///< 显式设置一个绝对宽度
@property (nonatomic) CGFloat width;

///< 设置一个最大的绝对宽，当需要计算宽度时会使用该值作为边界
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat minWidth;

///< 显示设置其绝对高
@property (nonatomic) CGFloat height;

///< 设置一个最大的绝对高，当需要计算高度时会使用该值作为边界
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat minHeight;

///< 显示设置其在模板中的位置
@property (nonatomic) CGPoint origin;

///< 显示设置其绝对的大小
@property (nonatomic) CGSize size;

///< 显示设置其绝对值的位置和大小
@property (nonatomic) CGRect frame;

///< 设置尺寸计算类型，default EUISizeTypeToFill
@property (nonatomic) EUISizeType sizeType;

///< 可指定布局在横向和纵向的相对位置（相对于templet考虑），默认是 EUIGravityHorzStart | EUIGravityVertStart
@property (nonatomic) EUIGravity gravity;

///< 外边距，总用于相邻布局对象的间距关系
@property (nonatomic, strong) EUIEdge *margin;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;

///< 内边距，当 layout 作为 templet 容器时，该值才有意义，作用于 SubLayouts
@property (nonatomic, strong) EUIEdge *padding;
@property (nonatomic) CGFloat paddingTop;
@property (nonatomic) CGFloat paddingBottom;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingRight;

///< 指定视图在 Z 轴的顺序
@property (nonatomic) EUILayoutZPostion zPosition;

///< 可设置一个唯一ID，便于快速查找
@property (nonatomic, copy) NSString *uniqueID;

///< 可重写 sizeThatFits： 方法返回的大小
@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

///< Node 需要知道自己如何计算大小
- (CGSize)sizeThatFits:(CGSize)constrainedSize;

///< 是否是可拉伸的，用于视图已有frame的情况，如果设置了，则会走Layout的布局规则，否则会按frame的设置走绝对布局
@property (nonatomic, getter=isFlexable) BOOL flexable;

///< 用于嵌套时做代码结构化
- (__kindof EUILayout *)configure:(void(^)(__kindof EUILayout *layout))block;

- (__kindof EUILayout * (^)(void(^)(__kindof EUILayout *)))config;

///< 用于扩展 autolayout 语法
- (__kindof EUILayout * (^)(void(^)(id)))make;

///< 获取Node当前一个有效的尺寸
- (CGSize)validSize;

@end
