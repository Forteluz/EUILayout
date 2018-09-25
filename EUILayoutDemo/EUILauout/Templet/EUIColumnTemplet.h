//
//  EUIColumnTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import <YogaKit/UIView+Yoga.h>

#define TColumn(...) [DCUIColumnTemplet templetWithItems:@[__VA_ARGS__]]

@interface EUIColumnTemplet : EUITemplet

- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout;
- (void)layoutTempletBased:(EUILayout *)node yoga:(YGLayout *)layout;

@end
