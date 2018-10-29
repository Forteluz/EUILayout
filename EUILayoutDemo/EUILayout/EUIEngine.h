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
 TODO :
    · 容器视图和容器模板的关系分析
    · 结构优化
 */
@interface EUIEngine : NSObject

/**
 *  EUIEngine 负责的跟视图
 */
@property (nonatomic, weak, readonly) UIView *view;

/**
 *  EUIEngine 负责的根模板
 */
@property (nonatomic, strong, readonly) EUITemplet *rootTemplet;


#pragma mark - Access

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithView:(UIView *)view;

/*!
 *  @brief 更新为一个指定的模板
 */
- (void)layoutTemplet:(EUITemplet *)templet;

/*!
 *  清空根模板上的所有内容
 */
- (void)cleanUp;

@end
