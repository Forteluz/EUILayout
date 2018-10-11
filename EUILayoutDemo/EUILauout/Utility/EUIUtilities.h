//
//  EUIUtilities.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/11.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//const CGSize EUIContainerMaxSize = (CGSize){0x100000, 0x100000};

typedef enum : unsigned short {
    EPStepNone = 0,
    EPStepX = 1 << 0,
    EPStepY = 1 << 1,
    EPStepW = 1 << 2,
    EPStepH = 1 << 3,
    EPStepFinished = 0x00F
} EPStep;

typedef struct {
    CGRect frame;
    EPStep step;
} CalculatCanvers;

NS_ASSUME_NONNULL_END
