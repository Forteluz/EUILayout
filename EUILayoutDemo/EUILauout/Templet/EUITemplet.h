//
//  EUITemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUINode.h"
#import "EUIParser.h"
#import "EUINode+Filter.h"

#pragma mark -

@class EUITempletView;

#pragma mark -

#ifndef TBase
#define TBase(...) [EUITemplet templetWithItems:@[__VA_ARGS__]]
#endif

@class EUILayout;

#pragma mark -

@interface EUITemplet : EUINode

#pragma mark - TODO
/**
 * TODO: 还需要支持模板级别的布局属性
 */
//@property (nonatomic) spacing; ///< 节点之间的间隔
//@property (nonatomic) gravity; ///< 模板内容总体的布局锚点
//@property (nonatomic) warp;    ///< 某些模板支持换行？

///< 布局解析器
@property (nonatomic, strong, nullable) EUIParser *parser;

///< 模板包含的所有子布局节点
@property (nonatomic, copy, readonly) NSArray <EUINode *> *nodes;

#pragma mark - Init Templet

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items __attribute__((objc_requires_super));
- (instancetype)init __attribute__((unavailable("Use '- (instancetype)initWithItems:' !")));
- (instancetype)initWithItems:(NSArray <EUIObject> *)items;

#pragma mark - Layout Nodes

///< 开始模板布局
- (void)layoutTemplet;

#pragma mark - Control Nodes

- (void)addNode:(EUIObject)node;
- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index;
- (void)removeNodeAtIndex:(NSInteger)index;
- (void)removeAllNodes;

- (__kindof EUINode *)nodeAtIndex:(NSInteger)index;
- (__kindof EUINode *)nodeWithUniqueID:(NSString *)uniqueID; //还未实现

#pragma mark - Calculate Nodes

///< Reset 会将模板上所有的视图全部做 removeFromSuper 操作
- (void)reset;

///< 相对布局时，告诉子节点关于容器的尺寸
- (CGSize)suggestConstraintSize;

///< 布局子节点
- (void)layoutNodes:(NSArray <EUIObject> *)nodes;

@end

#pragma mark -

__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView
@property (nonatomic, copy) void (^layoutSubviewsBlock)(void);
@end
