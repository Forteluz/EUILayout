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

@class EUIEngine;
@class EUITempletView;

#pragma mark -

#ifndef TBase
#define TBase(...) [[EUITemplet alloc] initWithItems:@[__VA_ARGS__]]
#endif

#pragma mark -

@interface EUITemplet : EUINode {
    @package
    NSMapTable *_uniqueIDTable;
}

/*!
 *  当前模板布局体系中的根模板
 */
@property (nonatomic, readonly) EUITemplet *rootTemplet;

/*!
 *  布局解析器，可替换该对象用于分析不同的布局逻辑
 */
@property (nonatomic, strong) EUIParser *parser;

/*!
 *  模板包含的所有子布局节点
 */
@property (nonatomic, copy, readonly) NSArray <EUINode *> *nodes;

/*!
 *  layout计算完成的回调
 */
@property (nonatomic, copy) void (^didLoadSubnodesBlock)(EUITemplet *templet);

#pragma mark - Init Templet

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

/*!
 *  唯一的初始化方法，但通常使用更简单的方法生成模板，比如 : TBase(EUIObject, ...)
 */
- (instancetype)initWithItems:(NSArray <EUIObject> *)items;

#pragma mark - Layout Nodes

/*!
 *  开始计算所有的 sublayouts，计算完成后不会更新视图;
 *  整个过程会拆成三步：
 *      1 - willLoadSubnodes
 *      2 - loadSubnodes:
 *      3 - didLoadSubnodes
 */
- (void)layout;

/*!
 *  计算 sublayout 之前，不同模板可能会做些预处理
 */
- (void)willLoadSubnodes;

/*!
 *  开始加载并计算所有的 sublayouts
 */
- (void)loadSubnodes:(NSArray <EUIObject> *)nodes;

/*!
 *  所有的 sublayouts 计算完成，并会抛出回调 didLoadSubnodesBlock
 */
- (void)didLoadSubnodes;

/*!
 *  计算每个 layout 的具体实现，如果未指定解析上下文 contex，会按照默认的方式执行计算过程
 */
- (void)loadNode:(EUINode *)node preNode:(EUINode *)preNode context:(EUIParseContext *)context;

#pragma mark - Control Nodes

/*!
 *  在当前模板中添加一个布局 layout
 *  @see EUIObject
 *  @warning 调用后不会刷新，所以需要重新layout
 */
- (void)addNode:(EUIObject)object;

/*!
 *  在指定 index 位置插入一个 layout，如果 index 超出范围会插入最尾部或者头部；
 *
 *  @see EUIObject
 *  @warning 调用后不会刷新模板，所以需要重新layout
 */
- (void)insertNode:(EUIObject)object atIndex:(NSInteger)index;

/*!
 *  替换 index 处的layout，如果模板中已经存在 layout，会替换失败
 */
- (void)replaceNode:(EUIObject)object atIndex:(NSInteger)index;
- (void)replaceNode:(EUIObject)object atNode:(EUIObject)atNode;

/*!
 *  移除模板上的一个指定 layout，支持 EUIObject 类型
 *
 *  @see EUIObject
 *  @warning 调用后不会刷新模板，所以需要重新layout
 */
- (void)removeNode:(EUIObject)object;

/*!
 *  移除指定 index 的 layout，因为有嵌套模板的可能，所以 remove操作要慎重
 *  如有模板：TRow(a, TRow(x, y), c, d);
 *  如果移除 [index == 1], 会将整个 TRow(x, y) 移除;
 *
 *  @warning 调用后不会刷新模板，所以需要重新layout
 */
- (void)removeNodeAtIndex:(NSInteger)index;

/*!
 *  移除全部的layout;
 *  @warning 调用后不会刷新，所以需要重新layout;
 */
- (void)removeAllSubnodes;

/*!
 *  查询对应 index 的 layout; index 的范围是 [0 -- (count - 1)];
 *  @warning index 错误会返回 nil;
 *  @return 一个 layout 对象（或者 Templet 对象）
 */
- (__kindof EUINode *)nodeAtIndex:(NSInteger)index;

#pragma mark -

- (NSArray <UIView *> *)loadSubviews;

#pragma mark -

/*!
 *  模板是否存在有效的宽和高，模板布局时必须有依据有效宽高进行处理
 */
- (BOOL)isBoundsValid;

/*!
 *  是否是根模板
 */
- (BOOL)isRoot;

@end

#pragma mark -

__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView
@property (nonatomic, copy) void (^layoutSubviewsBlock)(void);
@end
