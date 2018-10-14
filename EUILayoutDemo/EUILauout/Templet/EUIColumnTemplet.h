//
//  EUIColumnTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIBaseTemplet.h"

#define TColumn(...) [EUIColumnTemplet templetWithItems:@[__VA_ARGS__]]

@interface EUIColumnTemplet : EUIBaseTemplet

@end
