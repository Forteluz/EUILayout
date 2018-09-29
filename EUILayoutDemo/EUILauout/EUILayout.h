//
//  EUILayout.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EUILayoutMetamacros.h"
///< Models
#import "EUILayoutPos.h"
#import "EUILayoutEdge.h"

#pragma mark -

typedef NS_ENUM(NSInteger, EUILayoutSizeType) {    
    EUILayoutSizeToFit,
    EUILayoutSizeToFill
};

typedef NS_ENUM(NSInteger, EUILayoutAlign) {
    EUILayoutAlignStart,
    EUILayoutAlignCenter, ///<
    EUILayoutAlignEnd
};

typedef NS_ENUM(NSInteger, EUILayoutZPostion) {
    EUILayoutZPostionLow     = 100,
    EUILayoutZPostionNormal  = 1000,  ///< Default
    EUILayoutZPostionHigh    = 10000,
};

#pragma mark -

UIKIT_STATIC_INLINE EUILayoutEdge *EUIEdgeMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    return [EUILayoutEdge edgeWithInsets:(UIEdgeInsets) {
        top, left, bottom, right
    }];
}

#pragma mark -

///< 只支持 UIView 、EUILayout 、EUITemplet 、NSArray
typedef id EUIObject;

static const NSInteger EUINone = NSIntegerMax;

/** Large positive number signifies that the property(float) is undefined.
 *Earlier we used to have YGundefined as NAN, but the downside of this is that
 *we can't use -ffast-math compiler flag as it assumes all floating-point
 *calculation involve and result into finite numbers. For more information
 *regarding -ffast-math compiler flag in clang, have a look at
 *https://clang.llvm.org/docs/UsersManual.html#cmdoption-ffast-math
 **/
#define EUIUndefined 10E20F

#pragma mark -

@interface EUILayout : NSObject

///< 作为容器时是否创建模板容器视图，默认YES
@property (nonatomic, assign) BOOL isHolder;

///<
@property (nonatomic, weak) EUILayout *superLayout;

///< Node 的 view 视图，通常该属性不需要显式处理
@property (nonatomic, weak) UIView *view;

#pragma mark - 关于尺寸

///< 绝对宽
@property (nonatomic, assign) CGFloat width;

///< 绝对高
@property (nonatomic, assign) CGFloat height;

///< 绝对尺寸
@property (nonatomic, assign) CGSize size;

///< 绝对 x 坐标
@property (nonatomic, assign) CGFloat x;

///< 绝对 y 坐标
@property (nonatomic, assign) CGFloat y;

///< 绝对坐标
@property (nonatomic, assign) CGPoint origin;

///< origin + size
@property (nonatomic, assign) CGRect frame;

///< 外边距
@property (nonatomic, strong) EUILayoutEdge *margin;

///< 内边距
@property (nonatomic, strong) EUILayoutEdge *padding;

///< DCUILayoutSizeTypeDefault
@property (nonatomic, assign) EUILayoutSizeType sizeType;

///<
@property (nonatomic, assign) EUILayoutAlign vAlign; ///< 垂直

///<
@property (nonatomic, assign) EUILayoutAlign hAlign; ///< 水平

///< z 轴层次
@property (nonatomic, assign) NSInteger zPosition;

///< 走你
@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

#pragma mark -

+ (instancetype)node:(UIView *)view;

- (CGSize)sizeThatFits:(CGSize)constrainedSize;

- (EUILayout *)configure:(void(^)(EUILayout *))block;

@end

@interface EUILayout (Helper)

+ (EUILayout * __nullable)findNode:(EUIObject)object;
+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <EUIObject> *)items;

@end

@interface  EUILayout (CallChaining)
- (__kindof EUILayout * (^)(EUILayoutSizeType))t_sizeType;
- (__kindof EUILayout * (^)(CGFloat))t_height;
- (__kindof EUILayout * (^)(CGFloat))t_width;
//- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))t_margin;
//- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))e_padding;
@end

