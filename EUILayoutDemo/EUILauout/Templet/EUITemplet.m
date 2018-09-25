//
//  EUITemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITemplet.h"
#import "UIView+EUILayout.h"

@interface EUITemplet()
@property (nonatomic, copy, readwrite) NSArray <EUILayout *> *nodes;
@end

@implementation EUITemplet

+ (instancetype)templetWithItems:(NSArray <id> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
    id one = [[self.class alloc] initWithItems:items];
    return one;
}

- (instancetype)initWithItems:(NSArray <id> *)items {
    self = [super init];
    if (self) {
        _nodes = [EUILayout nodesFromItems:items];
        self.sizeType = EUILayoutSizeTypeTempletBased;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc templet:%@", self);
}

- (void)updateInView:(UIView *)view {
    [self setView:view];
    if ( view ) {
        [view eui_setLayout:self];
    }
}

- (void)cleanTempletIfNeeded {
    NSInteger count = self.view.subviews.count;
    if (count == 0) {
        return;
    }
    [self.view.subviews enumerateObjectsUsingBlock:^
     (__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj.eui_layout isKindOfClass:EUITemplet.class]) {
             EUITemplet *one = (EUITemplet *)obj.eui_layout;
             [one cleanTempletIfNeeded];
             [one.view removeFromSuperview];
             (one.view = nil);
         } else {
             [obj removeFromSuperview];
             (obj = nil);
         }
     }];
}

- (void)reset {
    [self cleanTempletIfNeeded];
}

- (void)layoutTemplet {
    [self reset];
    
    NSMutableArray <EUITemplet *> *templets = nil;
    NSArray <EUILayout *> *nodes = self.nodes;
    
    NSInteger index = 0;
    EUILayout *lastNode = nil;
    
    for (EUILayout *node in nodes) {
        UIView *nodeView = node.view;
        BOOL isTempletNode = [node isKindOfClass:EUITemplet.class];
        if ( isTempletNode ) {
            if (!nodeView) {
                nodeView = [EUITempletView imitateByView:nil];
                [(EUITemplet *)node updateInView:nodeView];
            }
        }
        if (!nodeView) {
            continue;
        }
        
        [self layoutNode:node];
        
        if (isTempletNode) {
            if (EUILayoutSizeTypeAuto == node.sizeType) {
                [(EUITemplet *)node layoutTemplet];
            } else {
                if (!templets) {
                     templets = @[].mutableCopy;
                }
                [templets addObject:(EUITemplet *)node];
            }
        }
        
        if (lastNode) {
            [self.view insertSubview:nodeView aboveSubview:lastNode.view];
        } else if (!nodeView.superview) {
            [self.view addSubview:nodeView];
        } else {
            [self.view bringSubviewToFront:nodeView];
        }
        
        lastNode = node;
        index ++;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^
                   {
                       for (EUITemplet *one in templets) {
                           [one layoutTemplet];
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [templets count];
                       });
                   });
}

- (void)layoutNode:(EUILayout *)node {
    CGRect r = {0};
    if (!CGPointEqualToPoint(CGPointZero, node.origin)) {
        r.origin = node.origin;
    } else {
        r.origin = (CGPoint) { node.padding.left, node.padding.top };
    }
    if (!CGSizeEqualToSize(CGSizeZero, node.size)) {
        r.size = node.size;
    } else {
        r.size = [node.view bounds].size;
    }
    [node.view setFrame:r];
}

- (CGSize)sizeThatFits:(CGSize)constrainedSize {
    CGSize size = {0};
    return size;
}

@end

@implementation EUITempletView
+ (EUITempletView *)imitateByView:(UIView *)view {
    CGRect r = view ? view.bounds : CGRectZero;
    EUITempletView *one = [[EUITempletView alloc] initWithFrame:r];
    one.backgroundColor = DCRandomColor;
    return one;
}
@end
