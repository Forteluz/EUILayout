//
//  TestTEasyViewController+View1.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/28.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "TestTEasyViewController+View1.h"

@implementation TestTEasyViewController (View1)

- (void)setupView1 {
//    self.view1.eui_layout.frame = CGRectMake(100, 100, 100, 100);
//    self.view1.eui_layout.margin = EUIEdgeMake(30, 30, 0, 0);
    self.view1.eui_layout.size = CGSizeMake(100, 100);
    
    if(EUILayoutAlignStart == self.view1.eui_layout.hAlign) {
        self.view1.eui_layout.hAlign = EUILayoutAlignCenter;
    } else if (EUILayoutAlignCenter == self.view1.eui_layout.hAlign) {
        self.view1.eui_layout.hAlign = EUILayoutAlignEnd;
    } else {
        self.view1.eui_layout.hAlign = EUILayoutAlignStart;
    }
    if(EUILayoutAlignStart == self.view1.eui_layout.vAlign) {
        self.view1.eui_layout.vAlign = EUILayoutAlignCenter;
    } else if (EUILayoutAlignCenter == self.view1.eui_layout.vAlign) {
        self.view1.eui_layout.vAlign = EUILayoutAlignEnd;
    } else {
        self.view1.eui_layout.vAlign = EUILayoutAlignStart;
    }
}

- (void)setupViewPostion {
    EUILayout *one = self.view1.eui_layout;

    ///< a
    one.margin = EUIEdgeMake(10, 10, 0, 0);
    
    ///< b
    one.origin = CGPointMake(100, 100);
}

- (void)setupViewSize {
    EUILayout *one = self.view1.eui_layout;
    
    one.margin = EUIEdgeMake(10, 10, 10, 10);
    
    one.sizeType = EUILayoutSizeToFit;
    
    one.size = CGSizeMake(100, 100);
    
}

@end
