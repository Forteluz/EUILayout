//
//  TestButton.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/16.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestButton : UIButton
@property (nonatomic, copy) void (^action)(UIButton *one);
@end

NS_ASSUME_NONNULL_END
