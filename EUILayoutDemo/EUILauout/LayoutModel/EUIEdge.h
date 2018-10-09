//
//  EUIEdge.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/29.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EUIEdge : NSObject
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
+ (instancetype)edgeWithInsets:(UIEdgeInsets)insts;
@end

@interface EUILayoutMargin  : EUIEdge @end
@interface EUILayoutPadding : EUIEdge @end

NS_ASSUME_NONNULL_END
