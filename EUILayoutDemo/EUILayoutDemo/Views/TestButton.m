//
//  TestButton.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/16.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestButton.h"

@implementation TestButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonAction {
    if (self.action) {
        self.action(self);
    }
}

- (void)dealloc {
    NSLog(@"TestButton :%@ dealloc", self);
}

@end
