//
//  EUITestMidCard.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestMidCard.h"

@implementation EUITestMidCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

+ (CGFloat)height:(id)object {
    return 108;
}

@end
