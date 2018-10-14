//
//  EUILayouter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUILayouter.h"

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
        !(self.dataSource) ||
        ![self.dataSource respondsToSelector:@selector(templetWithLayouter:)])
    {
        return;
    }
    EUITemplet *templet = [self.dataSource templetWithLayouter:self];
    [self updateTemplet:templet];
}

- (void)updateTemplet:(EUITemplet *)templet {
    if ([templet isHolder]) {
        [templet updateInView:self.rootContainer];
    } else {
        EUITempletView *one = [self.view viewWithTag:1001];
        if ( one && one.superview ) {
            [one removeFromSuperview];
        }
        one = nil;
    }
    EUIAfter(dispatch_get_main_queue(), 0, ^{
        [templet layoutTemplet];
    });
    [self setRootTemplet:templet];
}

#pragma mark - Root Container

- (EUITempletView *)rootContainer {
    EUITempletView *one = [self.view viewWithTag:1001];
    if (one == nil) {
        one = [EUITempletView imitateByView:self.view];
        one.tag = 1001;
        [self.view addSubview:one];
    }
    return one;
}

- (BOOL)needYogaRootContainer {
    return YES;
}

@end
