//
//  EUIRowTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseTemplet.h"
#import <YogaKit/UIView+Yoga.h>

#define TRow(...) [EUIRowTemplet templetWithItems:@[__VA_ARGS__]]

/**
 Row 模板，从上往下顺序布局
 */
@interface EUIRowTemplet : EUIBaseTemplet

@property (nonatomic, assign) BOOL flexable;

- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout;
- (void)layoutTempletBased:(EUILayout *)node yoga:(YGLayout *)layout;

@end
