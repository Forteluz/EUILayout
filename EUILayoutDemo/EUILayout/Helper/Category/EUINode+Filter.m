//
//  EUINode+Filter.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUINode+Filter.h"
#import "UIView+EUILayout.h"
#import <objc/runtime.h>

static const void *kEUINodeFrameCacheAssociatedKey = &kEUINodeFrameCacheAssociatedKey;

@implementation EUILayout (Filter)

+ (EUILayout * __nullable)findNode:(EUIObject)object {
    if (!object) return nil;
    EUILayout *one = nil;
    if ([object isKindOfClass:UIView.class]) {
        one = [(UIView *)object eui_layout];
        one.view = object;
    } else if ([object isKindOfClass:EUILayout.class]) {
        one = object;
    } else {
        return nil;
    }
    return one;
}

+ (NSArray <EUILayout *> *)nodesFromItems:(NSArray <id> *)items {
    if (!items || items.count == 0) {
        return nil;
    }
//    if (items.count == 1 && [[items objectAtIndex:0] isKindOfClass:NSArray.class]) {
//        items = items[0];
//    }
    NSMutableArray *one = @[].mutableCopy;
    for (id item in items) {
        BOOL isArray = [item isKindOfClass:NSArray.class];
        if ( isArray ) {
            NSArray *arrayItem = (NSArray *)item;
            if (arrayItem.count) {
                NSArray *nodes = [self nodesFromItems:arrayItem];
                [one addObjectsFromArray:nodes];
            }
            continue;
        }
        EUILayout *node = [EUILayout findNode:item];
        if (node) {
            [one addObject:node];
        }
    }
    return one;
}

#pragma mark -

- (void)setCacheFrame:(CGRect)cacheFrame {
    NSValue *one = [NSValue valueWithCGRect:cacheFrame];
    objc_setAssociatedObject(self,
                             kEUINodeFrameCacheAssociatedKey,
                             one,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)cacheFrame {
    NSValue *value = objc_getAssociatedObject(self, kEUINodeFrameCacheAssociatedKey);
    if (value) {
        return [value CGRectValue];
    }
    return CGRectMake(NSNotFound, NSNotFound, NSNotFound, NSNotFound);
}

@end
