//
//  EUIRowTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import <YogaKit/UIView+Yoga.h>

#define TRow(...) [EUIRowTemplet templetWithItems:@[__VA_ARGS__]]

@interface EUIRowTemplet : EUITemplet

- (void)layoutNodeBased:(EUILayout *)node yoga:(YGLayout *)layout;
- (void)layoutTempletBased:(EUILayout *)node yoga:(YGLayout *)layout;

@end
