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

@class EUILayout;
@class EUITempletView;

#pragma mark -

#ifndef TBase
#define TBase(...) [EUITemplet templetWithItems:@[__VA_ARGS__]]
#endif

#pragma mark -

@interface EUITemplet : EUINode {
    @package
    NSMapTable *_uniqueIDTable;
}

///< 作为模板时是否创建容器视图，默认YES
@property (nonatomic, assign) BOOL isHolder;

///< 根模板
@property (nonatomic, readonly) EUITemplet *rootTemplet;

#pragma mark - TODO

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
- (void)layout;

///< 布局之前
- (void)layoutWillStart;

///< 布局指定的节点
- (void)layoutNodes:(NSArray <EUIObject> *)nodes;

///< layout结束
- (void)layoutDidEnd;

///< 可显式修改已存在的布局Node
- (void)layoutNode:(EUINode *)node preNode:(EUINode *)preNode context:(EUIParseContext *)context;

///< 清空所有的子视图
- (void)clearSubviewsIfNeeded;

#pragma mark - Control Nodes

///< 添加一个node
- (void)addNode:(EUIObject)node;

///< 插入一个Node
- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index;

///< 移除一个Node
- (void)removeNodeAtIndex:(NSInteger)index;

///< 删除所有Node
- (void)removeAllNodes;

- (__kindof EUINode *)nodeAtIndex:(NSInteger)index;
- (__kindof EUINode *)nodeWithUniqueID:(NSString *)uniqueID; //还未实现

@end

#pragma mark -

__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView
@property (nonatomic, copy) void (^layoutSubviewsBlock)(void);
@end
