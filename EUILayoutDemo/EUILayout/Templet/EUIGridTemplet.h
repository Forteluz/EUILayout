//
//  EUIGridTemplet.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUITemplet.h"

///===============================================
/// Grid 暂时是一个临时的模板，不支持部分模板的功能，比如
/// 模板的查询，删除等，该模板还有待开发，：）
///===============================================
#define TGrid(...) [[EUIGridTemplet alloc] initWithItems:@[__VA_ARGS__]]

@interface EUIGridTemplet : EUITemplet
@property (nonatomic) NSUInteger columns;
@property (nonatomic) NSUInteger rows;
//@property (nonatomic) CGFloat spacing;

- (EUIGridTemplet * (^)(NSUInteger))set_columns;
- (EUIGridTemplet * (^)(void(^)(__kindof EUINode *layout)))config;

@end
