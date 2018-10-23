//
//  EUILayout+Filter.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUILayout.h"

@interface EUILayout (Filter)
@property (nonatomic, assign) CGRect cacheFrame;

+ (EUILayout * __nullable)findNode:(EUIObject)object;

+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <EUIObject> *)items;

@end
