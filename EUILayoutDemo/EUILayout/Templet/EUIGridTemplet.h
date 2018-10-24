//
//  EUIGridTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUITemplet.h"

#define TGrid(...) [[EUIGridTemplet alloc] initWithItems:@[__VA_ARGS__]]

@interface EUIGridTemplet : EUITemplet
@property (nonatomic) NSUInteger columns;
@property (nonatomic) NSUInteger rows;
//@property (nonatomic) CGFloat spacing;
@end
