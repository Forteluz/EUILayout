//
//  TestFactory.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EUIGoto(_TARGET_,_NAME_) \
UIViewController *one = [NSClassFromString(_NAME_) new]; \
[_TARGET_ presentViewController:one animated:YES completion:NULL];

UILabel * EText(NSString *text);
UIButton * EButton(NSString *title, dispatch_block_t block);
