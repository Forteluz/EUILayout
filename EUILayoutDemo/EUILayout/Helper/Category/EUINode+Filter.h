//
//  EUINode+Filter.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUINode.h"

@interface EUINode (Filter)

/*!
 *  计算过的 frame
 */
@property (nonatomic, assign) CGRect cacheFrame;

- (BOOL)needCalculate;

+ (EUINode * __nullable)findNode:(EUIObject)object;

+ (NSArray <EUINode *> *)nodesFromItems:(NSArray <EUIObject> *)items;


@end
