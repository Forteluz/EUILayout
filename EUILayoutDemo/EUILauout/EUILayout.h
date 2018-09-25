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
    ///< 模板布局时，优先使用 Node 的 size 进行布局，如果没有会自动取 View 的 size,
    ///< 如果取不到任何有效的 size，会默认使用 EUILayoutSizeTypeTempletBased 进行排版。
    EUILayoutSizeTypeAuto,
    
    ///< 如果显示使用了基于模板的布局，则会忽略掉 Node 节点和 view 的尺寸进行布局。
    EUILayoutSizeTypeTempletBased,
};

#pragma mark -

///< Just subclass of UIView and DCUILayoutNode
typedef id EUIObject;

#pragma mark -

@interface EUILayout : NSObject

///< Node 的 view 视图，通常该属性不需要显式处理
@property (nonatomic, weak) UIView *view;

///< 绝对尺寸
@property (nonatomic, assign) CGSize size;

///< 绝对坐标
@property (nonatomic, assign) CGPoint origin;

///< 外边距(只作用于布局 Node)
@property (nonatomic, assign) UIEdgeInsets margin;

///< 内边距(只作用于 Templet)
@property (nonatomic, assign) UIEdgeInsets padding;

///< DCUILayoutSizeTypeDefault
@property (nonatomic, assign) EUILayoutSizeType sizeType;

@property (nonatomic, copy) CGSize (^sizeThatFits)(CGSize constrainedSize);

#pragma mark -

+ (instancetype)node:(UIView *)view;

- (CGSize)sizeThatFits:(CGSize)constrainedSize;

@end

@interface EUILayout (Helper)

+ (EUILayout *)findNode:(EUIObject)object;
+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <id> *)items;

@end

@interface  EUILayout (CallChaining)
- (__kindof EUILayout * (^)(EUILayoutSizeType))t_sizeType;
- (__kindof EUILayout * (^)(CGFloat))t_height;
- (__kindof EUILayout * (^)(CGFloat))t_width;
- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))t_margin;
- (__kindof EUILayout * (^)(CGFloat, CGFloat, CGFloat, CGFloat))t_padding;
@end

