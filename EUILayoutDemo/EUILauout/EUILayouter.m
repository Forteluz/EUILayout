//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayouter.h"

#pragma mark -

NSInteger EUIRootViewTag() {
    static NSInteger tag;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tag = @"EUILayouterRootContainer".hash;
    });
    return tag;
}

#pragma mark -

@interface EUILayouter()
@property (nonatomic, strong, readwrite) UIView *view;
@property (nonatomic, strong, readwrite) EUITemplet *rootTemplet;
@end

@implementation EUILayouter

+ (instancetype)layouterByView:(UIView *)view {
    if (!view) {
        return nil;
    }
    EUILayouter *one = [[EUILayouter alloc] init];
    one.view = view;
    return one;
}

#pragma mark - Update

- (void)update {
    if (!(self.view) ||
        !(self.delegate) ||
        ![self.delegate respondsToSelector:@selector(templetWithLayouter:)])
    {
        return;
    }
    EUITemplet *templet = [self.delegate templetWithLayouter:self];
    [self updateTemplet:templet];
}

- (void)updateTemplet:(EUITemplet *)templet {
    if ([templet isHolder]) {
        [templet setView:self.rootContainer];
    } else {
        EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
        if ( one && one.superview ) {
            [one removeFromSuperview];
        }
        one = nil;
    }
    EUIAfter(dispatch_get_main_queue(), 0, ^{
        [self updateRootTempletFrame:templet];
        [templet layoutTemplet];
    });
    [self setRootTemplet:templet];
}

- (void)updateRootTempletFrame:(EUITemplet *)templet {
    CGRect frame = (CGRect){.origin = {0}, .size = self.view.bounds.size};
    
    if (EUIValid(templet.x)) {
        frame.origin.x = templet.x;
    } else if (EUIValid(templet.margin.left)) {
        frame.origin.x = templet.margin.left;
    }
    if (EUIValid(templet.y)) {
        frame.origin.y = templet.y;
    } else if (EUIValid(templet.margin.top)) {
        frame.origin.y = templet.margin.top;
    }
    if (EUIValid(templet.width)) {
        frame.size.width = templet.width;
    } else if (EUIValid(templet.margin.right) || EUIValid(templet.margin.left)) {
        frame.size.width = self.view.bounds.size.width - EUIValue(templet.margin.left) - EUIValue(templet.margin.right);
    }
    if (EUIValid(templet.height)) {
        frame.size.height = templet.height;
    } else if (EUIValid(templet.margin.bottom) || EUIValid(templet.margin.top)) {
        frame.size.height = self.view.bounds.size.height - EUIValue(templet.margin.top) - EUIValue(templet.margin.bottom);
    }
    [templet.view setFrame:frame];
}

#pragma mark - Root Container

- (EUITempletView *)rootContainer {
    EUITempletView *one = [self.view viewWithTag:EUIRootViewTag()];
    if (one == nil) {
        one = [EUITempletView new];
        one.tag = EUIRootViewTag();
        [self.view addSubview:one];
    }
    return one;
}

@end
