//
//  EUILayouter.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EUITemplet.h"

#pragma mark -
@class EUILayout;
@protocol EUILayouterDelegate <NSObject>

/*!
 *  @brief 返回一个模板
 */
- (EUITemplet *)templetWithLayouter:(EUILayout *)layouter;

@end

@interface EUILayout : NSObject

@property (nonatomic, strong, readonly) UIView *view;

@property (nonatomic, weak) id <EUILayouterDelegate> delegate;

@property (nonatomic, strong, readonly) EUITemplet *rootTemplet;

#pragma mark -

/*!
 *  @brief 生成一个布局模板示例
 */
+ (instancetype)layouterByView:(UIView *)view;

/*!
 *  @brief 更新当前数据源返回的模板
 */
- (void)update;

/*!
 *  @brief 更新为一个指定的模板
 */
- (void)updateTemplet:(EUITemplet *)templet;

@end
