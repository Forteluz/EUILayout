//
//  EUINode.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUIEdge.h"
#import "EUIMacro.h"
#import "EUIAssert.h"
#import "EUIUtilities.h"

#pragma mark -

typedef NS_OPTIONS(NSUInteger, EUIGravity) {
    EUIGravityNone       = 0,
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

/*
typedef NS_ENUM(NSInteger, EUILayoutZPostion) {
    EUILayoutZPostionDefault = 1,    ///< Default
    EUILayoutZPostionLow     = 100,
    EUILayoutZPostionNormal  = 1000,
    EUILayoutZPostionHigh    = 10000,
};
 */

#pragma mark -

UIKIT_STATIC_INLINE EUIEdge *EUIEdgeMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return [EUIEdge edgeWithInsets:(UIEdgeInsets) {
        top, left, bottom, right
    }];
}

#pragma mark -

///< 只支持 UIView 、EUINode 、EUITemplet 、NSArray、[NSNull null]
typedef id EUIObject;

#pragma mark -

@interface EUINode : NSObject

@property (nonatomic, weak) __kindof EUINode *templet; ///< layout 所依赖的模板

@property (nonatomic, readonly) BOOL isTemplet; ///< 是否是一个模板

@property (nonatomic, strong) UIView *view; ///< layout 负责布局的视图对象

#pragma mark - Absolute Position & Size

///===============================================
/// 绝对的属性会让 layout 在模板中有固定布局
///===============================================

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGRect frame;

#pragma mark - Relative Position & Size

///===============================================
/// 相对的属性会让 layout 在模板中自动计算相对布局
///===============================================

@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat minHeight;

/*!
 *  设置尺寸计算类型，default EUISizeTypeToFill
 */
@property (nonatomic) EUISizeType sizeType;

/*!
 *  可指定布局在横向和纵向的相对位置（相对于templet考虑），默认是 EUIGravityHorzStart | EUIGravityVertStart
 */
@property (nonatomic) EUIGravity gravity;

/*!
 *  外边距，总用于相邻布局对象的间距关系
 */
@property (nonatomic, strong) EUIEdge *margin;
@property (nonatomic) CGFloat marginTop;
@property (nonatomic) CGFloat marginBottom;
@property (nonatomic) CGFloat marginLeft;
@property (nonatomic) CGFloat marginRight;

/*!
 *  内边距，当 layout 作为 templet 容器时，该值才有意义，作用于 SubLayouts
 */
@property (nonatomic, strong) EUIEdge *padding;
@property (nonatomic) CGFloat paddingTop;
@property (nonatomic) CGFloat paddingBottom;
@property (nonatomic) CGFloat paddingLeft;
@property (nonatomic) CGFloat paddingRight;


#pragma mark - 其他

/*!
 *  可以给 layout 设置一个唯一标识，方便查询
 */
@property (nonatomic, copy) NSString *uniqueID;

/*!
 *  可重写 sizeThatFits：方法使得 layout 可以在模板中相对布局时获得有效尺寸
 */
@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

/*!
 *  当触发相对布局时，layout 需要知道自己的尺寸如何变化
 *  如果 layout 有 view，会自动调用 view sizeThatFits: 方法获取有效 size,
 *  同时 layout 也可以重写 sizeThatFits block 来自定义实现
 */
- (CGSize)sizeThatFits:(CGSize)constrainedSize;

///< 是否是可拉伸的，用于视图已有frame的情况，如果设置了，则会走Layout的布局规则，否则会按frame的设置走绝对布局
@property (nonatomic, getter=isFlexable) BOOL flexable;

/*!
 *  从另一个 layout 中继承对自己有效的属性
 */
- (void)inheritBy:(EUINode *)layout;

/*!
 *  用于嵌套时做代码结构化
 */
- (__kindof EUINode *)configure:(void(^)(__kindof EUINode *layout))block;

///< 获取Node当前一个有效的尺寸
- (CGSize)validSize;

#pragma mark - TODO

/*
 TODO : 待实现的功能
 ///< 指定视图在 Z 轴的顺序
 @property (nonatomic) EUILayoutZPostion zPosition;

 */

@end
