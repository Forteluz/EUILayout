//
//  EUITemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayout.h"

#pragma mark -

@class EUITempletView;

#pragma mark -

#define TEasy(...) [EUITemplet templetWithItems:@[__VA_ARGS__]]

#pragma mark -

@interface EUITemplet : EUILayout

///< 作为容器时是否创建模板容器视图，默认YES
@property (nonatomic, assign) BOOL isHolder;

///< 模板包含的所有子布局节点
@property (nonatomic, copy, readonly) NSArray <EUILayout *> *nodes;

///< 避免使用的初始化方法
- (instancetype)init __attribute__((unavailable("应该使用 templetWithItems: 来初始化一个模板")));

///< 正确的初始化方法
+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items;

///< 在 view 上创建一个布局模板
- (void)updateInView:(UIView *)view;

///< 刷新布局模板
- (void)layoutTemplet __attribute__((objc_requires_super));

///< 刷新布局节点
- (void)layoutNode:(EUILayout *)node;

- (void)insertNode:(EUIObject)node;

///< Reset
- (void)reset;

@end

#pragma mark -

///< 作为布局模板的容器视图
__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView

+ (EUITempletView *)imitateByView:(UIView *)view;

@end
