//
//  EUIColumnTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIRowTemplet.h"

#define TColumn(...) [EUIColumnTemplet templetWithItems:@[__VA_ARGS__]]

@interface EUIColumnTemplet : EUIRowTemplet

@end
