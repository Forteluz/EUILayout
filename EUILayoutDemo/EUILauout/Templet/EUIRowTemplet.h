//
//  EUIRowTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIColumnTemplet.h"

#define TRow(...) [EUIRowTemplet templetWithItems:@[__VA_ARGS__]]

@interface EUIRowTemplet : EUIColumnTemplet

@end
