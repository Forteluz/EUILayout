//
//  EUITestMidCard.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestMidCard.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"

@implementation EUITestMidCard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.eui_height = [EUITestMidCard height:nil];
        self.time = EButton(@"TIME", NULL);
        self.from = EButton(@"FROM", NULL);
        self.to = EButton(@"TO", NULL);
        self.price = EButton(@"28元", NULL);
    }
    return self;
}

- (void)updateWithModel:(id)model {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.price.eui_gravity  = EUIGravityEnd;
    self.price.eui_sizeType = EUISizeTypeToFit;
    
    EUITemplet *templet = TColumn
    (
        TRow(self.time,
             self.from,
             self.to),
        self.price
    );
    [self eui_layout:templet];
}

+ (CGFloat)height:(id)object {
    return 108;
}

@end
