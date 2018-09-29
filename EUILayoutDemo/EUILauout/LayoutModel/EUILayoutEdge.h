//
//  EUILayoutEdge.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/29.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EUILayoutEdge : NSObject
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
+ (instancetype)edgeWithInsets:(UIEdgeInsets)insts;
@end

@interface EUILayoutMargin  : EUILayoutEdge @end
@interface EUILayoutPadding : EUILayoutEdge @end

NS_ASSUME_NONNULL_END
