//
//  EUILayouter.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EUITemplet;

/**
 TODO:
    × 支持监听视图尺寸变化时动态修改布局
 */
@interface EUIEngine : NSObject

/**
 *  布局管理器负责的视图
 */
@property (nonatomic, weak, readonly) UIView *view;

/**
 *  当前的根模板
 */
@property (nonatomic, strong, readonly) EUITemplet *rootTemplet;


#pragma mark - Access

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/*!
 *  @brief init
 */
- (instancetype)initWithView:(UIView *)view;

/*!
 *  @brief 更新为一个指定的模板
 */
- (void)layoutTemplet:(EUITemplet *)templet;

/*!
 *  清空所有的模板
 */
- (void)cleanUp;

@end
