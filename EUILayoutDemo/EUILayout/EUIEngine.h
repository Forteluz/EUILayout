//
//  EUILayouter.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EUITemplet;

/*!
 *  容器的布局引擎
 *
 */
@interface EUIEngine : NSObject

/**
 *  负责驱动布局的视图
 */
@property (nonatomic, weak, readonly) UIView *view;

/**
 *  负责驱动的视图模板
 */
@property (nonatomic, strong, readonly) EUITemplet *templet;

/*!
 *  布局引擎是否在工作
 */
@property (nonatomic, readonly) BOOL isWorking;

#pragma mark - Access

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithView:(UIView *)view;

/*!
 *  @brief 更新根模板
 */
- (void)updateTemplet:(EUITemplet *)templet;

/*!
 *  驱动模板布局
 */
- (void)lay;

/*!
 *  立即更新所有模板视图的 frame
 */
- (void)layoutIfNeeded;

/*!
 *  移除所有的视图
 */
- (void)removeSubviews;

/*!
 *  清空根模板上的所有内容
 */
- (void)cleanUp;

@end
