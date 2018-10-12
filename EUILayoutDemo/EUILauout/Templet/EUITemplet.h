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

///< 模板包含的所有子布局节点
@property (nonatomic, copy, readonly) NSArray <EUILayout *> *nodes;

+ (instancetype)templetWithItems:(NSArray <EUIObject> *)items;

- (instancetype)init __attribute__((unavailable("use initWithItems: for templet")));
- (instancetype)initWithItems:(NSArray <EUIObject> *)items;

///< 在 view 上创建一个布局模板
- (void)updateInView:(UIView *)view;

///< 刷新模板
- (void)layoutTemplet __attribute__((objc_requires_super));

- (void)addNode:(EUIObject)node;
- (void)insertNode:(EUIObject)node atIndex:(NSInteger)index;
- (void)removeNode:(EUIObject)node;
- (void)removeNodeAtIndex:(NSInteger)index;

///< Reset
- (void)reset;

- (CGSize)suggestConstraintSize;

#pragma mark - For Calculate

- (void)layoutNodes:(NSArray *)nodes;

- (void)layoutaSubNode:(EUILayout *)node
            preSubNode:(EUILayout *)preSubNode
                status:(EUICalculatStatus *)canvers
               context:(EUICalculatContext *)context;

- (void)calculateSizeForSubLayout:(EUILayout *)layout
                     preSubLayout:(EUILayout *)preSubLayout
                          canvers:(EUICalculatStatus *)canvers;

- (void)calculatePostionForSubLayout:(EUILayout *)layout
                        preSubLayout:(EUILayout *)preSubLayout
                             canvers:(EUICalculatStatus *)canvers;
@end

#pragma mark -

///< 作为布局模板的容器视图
__attribute__((objc_subclassing_restricted)) @interface EUITempletView : UIView
@property (nonatomic, copy) void (^layoutSubviewsBlock)(void);
+ (EUITempletView *)imitateByView:(UIView *)view;

@end
