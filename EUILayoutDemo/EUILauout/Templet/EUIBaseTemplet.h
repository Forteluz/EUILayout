//
//  EUIBaseTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/27.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"

#define TBase(...) [EUIBaseTemplet templetWithItems:@[__VA_ARGS__]]

NS_ASSUME_NONNULL_BEGIN

@interface EUIBaseTemplet : EUITemplet

@end

NS_ASSUME_NONNULL_END
