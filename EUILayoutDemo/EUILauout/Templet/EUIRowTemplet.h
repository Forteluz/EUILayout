//
//  EUIRowTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"

#define TRow(...) [EUIRowTemplet templetWithItems:@[__VA_ARGS__]]

/**
 Row 模板，从上往下顺序布局
 */
@interface EUIRowTemplet : EUITemplet
//@property (nonatomic) spacing; ///< 节点之间的间隔
@end
