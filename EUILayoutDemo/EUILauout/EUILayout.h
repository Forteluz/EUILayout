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

#pragma mark -

UIKIT_STATIC_INLINE UIEdgeInsets EUIEdgeMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    UIEdgeInsets insets = {top, left, bottom, right};
    return insets;
}

#pragma mark -

///< 只支持 UIView 、EUILayout 、EUITemplet 、NSArray
typedef id EUIObject;

static const NSInteger EUINone = NSIntegerMax;

///< CGSizeMake(EUINone, EUINone);

#pragma mark -

@interface EUILayout : NSObject

///< 作为容器时是否创建模板容器视图，默认YES
@property (nonatomic, assign) BOOL isHolder;

///<
@property (nonatomic, weak) EUILayout *superLayout;

///< Node 的 view 视图，通常该属性不需要显式处理
@property (nonatomic, weak) UIView *view;

///< 绝对尺寸
@property (nonatomic, assign) CGSize size;

///< 绝对坐标
@property (nonatomic, assign) CGPoint origin;

///< origin + size
@property (nonatomic, assign) CGRect frame;

///< 外边距(只作用于布局 Node)
@property (nonatomic, assign) UIEdgeInsets margin;

///< 内边距(只作用于 Templet)
@property (nonatomic, assign) UIEdgeInsets padding;

///< DCUILayoutSizeTypeDefault
@property (nonatomic, assign) EUILayoutSizeType sizeType;

@property (nonatomic, assign) EUILayoutAlign vAlign; ///< 垂直
@property (nonatomic, assign) EUILayoutAlign hAlign; ///< 水平

//@property (nonatomic, assign) CGFloat left;
//@property (nonatomic, assign) CGFloat right;
//@property (nonatomic, assign) CGFloat top;
//@property (nonatomic, assign) CGFloat bottom;

///< 走你
@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

#pragma mark -

+ (instancetype)node:(UIView *)view;

- (CGSize)sizeThatFits:(CGSize)constrainedSize;

@end

@interface EUILayout (Helper)

+ (EUILayout * __nullable)findNode:(EUIObject)object;
+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <EUIObject> *)items;

@end

@interface  EUILayout (CallChaining)
- (__kindof EUILayout * (^)(EUILayoutSizeType))t_sizeType;
- (__kindof EUILayout * (^)(CGFloat))t_height;
- (__kindof EUILayout * (^)(CGFloat))t_width;
- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))t_margin;
- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))e_padding;
@end

