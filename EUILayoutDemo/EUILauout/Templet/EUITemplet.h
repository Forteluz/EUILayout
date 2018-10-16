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

#pragma mark -

@interface EUITemplet : EUINode

@property (nonatomic, strong) EUIParser *parser;

///< 模板包含的所有子布局节点
@property (nonatomic, copy, readonly) NSArray <EUINode *> *nodes;

#pragma mark - Init Templet

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items;
- (instancetype)init __attribute__((unavailable("use initWithItems: for templet")));
- (instancetype)initWithItems:(NSArray <EUIObject> *)items;

#pragma mark - Layout Nodes

///< 开始模板布局
- (void)layoutTemplet; //__attribute__((objc_requires_super));

#pragma mark - Control Nodes

- (void)addNode:(EUIObject)node;
- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index;
- (void)removeNodeAtIndex:(NSInteger)index;
- (void)removeAllNodes;
- (__kindof EUINode *)nodeAtIndex:(NSInteger)index;

#pragma mark - Calculate Nodes

///< Reset 会将模板上所有的视图全部做 removeFromSuper 操作
- (void)reset;

- (CGSize)suggestConstraintSize;

- (void)layoutNodes:(NSArray *)nodes;

@end

#pragma mark -

///< 作为布局模板的容器视图
__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView
@property (nonatomic, copy) void (^layoutSubviewsBlock)(void);
@end
