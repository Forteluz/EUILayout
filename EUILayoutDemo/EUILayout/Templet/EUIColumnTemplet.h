//
//  EUIColumnTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"

#define TColumn(...) [[EUIColumnTemplet alloc] initWithItems:@[__VA_ARGS__]]

@interface EUIColumnTemplet : EUITemplet
//@property (nonatomic) spacing; ///< 节点之间的间隔
@end
