//
//  EUILayoutPos.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/29.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayoutPos.h"

@implementation EUILayoutPos {
    id _posVal;
}

-(EUILayoutPos * (^)(id val))equalTo {
    return ^id(id val){
        self -> _posVal = val;
        return self;
    };
}

@end
