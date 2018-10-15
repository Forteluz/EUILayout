//
//  EUINode.h
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
    EUIGravityHorzStart  = 1 << 1,
    EUIGravityHorzCenter = 1 << 2,
    EUIGravityHorzEnd    = 1 << 3,
    EUIGravityVertStart  = 1 << 4,
    EUIGravityVertCenter = 1 << 5,
    EUIGravityVertEnd    = 1 << 6,
};

typedef enum : unsigned short {
    ///< Fit 计算不利于性能优化，建议多使用 Fill 做填充式布局；
    EUISizeTypeNone = 0,
    EUISizeTypeToHorzFit = 1 << 7,
    EUISizeTypeToVertFit = 1 << 8,
    EUISizeTypeToFit = (EUISizeTypeToHorzFit | EUISizeTypeToVertFit),
    
    ///< Fill 的布局更利于性能的优化和理解 ：）
    EUISizeTypeToHorzFill = (EUIGravityHorzStart | EUIGravityHorzEnd),
    EUISizeTypeToVertFill = (EUIGravityVertStart | EUIGravityVertEnd),
    EUISizeTypeToFill = (EUISizeTypeToHorzFill | EUISizeTypeToVertFill),
} EUISizeType;

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

///< 只支持 UIView 、EUINode 、EUITemplet 、NSArray
typedef id EUIObject;

#pragma mark -

@interface EUINode : NSObject

///< 作为模板时是否创建容器视图，默认YES
@property (nonatomic, assign) BOOL isHolder;

///< layout 所依赖的模板
@property (nonatomic, weak) __kindof EUINode *templet;

///< layout 负责布局的视图对象
@property (nonatomic, strong) UIView *view;

///< 显式设置在模板中的 x 坐标
@property (nonatomic, assign) CGFloat x;

///< 显式设置在模板中的 y 坐标
@property (nonatomic, assign) CGFloat y;

///< 显式设置一个绝对宽度
@property (nonatomic, assign) CGFloat width;

///< 设置一个最大的绝对宽，当需要计算宽度时会使用该值作为边界
@property (nonatomic, assign) CGFloat maxWidth;

///< 显示设置其绝对高
@property (nonatomic, assign) CGFloat height;

///< 设置一个最大的绝对高，当需要计算高度时会使用该值作为边界
@property (nonatomic, assign) CGFloat maxHeight;

///< 显示设置其在模板中的位置
@property (nonatomic, assign) CGPoint origin;

///< 显示设置其绝对的大小
@property (nonatomic, assign) CGSize size;

///< 显示设置其绝对值的位置和大小
@property (nonatomic, assign) CGRect frame;

///< 外边距，总用于相邻布局对象的间距关系
@property (nonatomic, strong) EUIEdge *margin;

///< 内边距，当 layout 作为 templet 容器时，该值才有意义，作用于 SubLayouts
@property (nonatomic, strong) EUIEdge *padding;

///< 设置尺寸计算类型，
@property (nonatomic, assign) EUISizeType sizeType; ///< DCUILayoutSizeTypeDefault

///< 可指定布局在横向和纵向的相对位置（相对于templet考虑），默认是 EUIGravityHorzStart | EUIGravityVertStart
@property (nonatomic, assign) EUIGravity gravity;

///< 指定视图在 Z 轴的顺序
@property (nonatomic, assign) EUILayoutZPostion zPosition;

///< 可重写 sizeThatFits： 方法返回的大小
@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

+ (instancetype)node:(UIView *)view;

- (CGSize)sizeThatFits:(CGSize)constrainedSize;

- (__kindof EUINode *)configure:(void(^)(__kindof EUINode *node))block;

@end
