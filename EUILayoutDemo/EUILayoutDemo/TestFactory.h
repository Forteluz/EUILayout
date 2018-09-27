//
//  TestFactory.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define _SETButton(_N_, _TITLE_)  \
if (!self.view##_N_) { \
     self.view##_N_ = [TestFactory creatButton:_TITLE_ tag:_N_]; \
} \
[self.view##_N_ setTitle:_TITLE_ forState:UIControlStateNormal];\
[self.view##_N_ addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];

#define _DEFButton(_NAME_) \
    @property (nonatomic, strong) UIButton *_NAME_;

@interface TestFactory : NSObject

+ (UIButton *)creatButton:(NSString *)title
                      tag:(NSInteger)tag;

@end
