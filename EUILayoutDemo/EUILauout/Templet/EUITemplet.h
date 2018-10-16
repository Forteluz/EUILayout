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

///< 布局解析器
@property (nonatomic, strong) EUIParser *parser;

///< 模板包含的所有子布局节点
@property (nonatomic, copy, readonly) NSArray <EUINode *> *nodes;

#pragma mark - Init Templet

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items;
- (instancetype)init __attribute__((unavailable("Use '- (instancetype)initWithItems:' !")));
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
- (__kindof EUINode *)nodeWithUniqueID:(NSString *)uniqueID;

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
