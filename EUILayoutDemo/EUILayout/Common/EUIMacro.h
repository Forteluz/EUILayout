//
//  EUILayoutMarco.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#pragma mark - For Node

#define EUIShield(_VIEW_) _VIEW_

#pragma mark -

#ifndef EUI_CLAMP
#define EUI_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#pragma mark - FOR TEST

#define EUIColor(r, g, b) [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha : 1]
#define EUIRandomColor EUIColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define EUIAfter(_QUEUE_, _SEC_ , _BLOCK_) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_SEC_ * NSEC_PER_SEC)), _QUEUE_, _BLOCK_)

#define EUIKeyPath(_OBJ_,_KEYPATH_) @(((void)_OBJ_._KEYPATH_,#_KEYPATH_))

#pragma mark - FOR __attribute__

#define EUI_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))

#ifndef EUIOnExit
#define EUIOnExit \
__strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^
#endif

#ifndef EUI_UNAVAILABLE
#define EUI_UNAVAILABLE(message) __attribute__((unavailable(message)))
#endif

#pragma mark - LOG & DEBUG

#define EUI_LOGGING_ENABLED 1

#if EUI_LOGGING_ENABLED
#define EUILog( s, ... ) do { NSLog( @"EUI: %@", [NSString stringWithFormat: (s), ##__VA_ARGS__] ); } while(0)
#else
#define EUILog( s, ... )
#endif

#ifndef EUI_DEBUG_DESCRIPTION_ENABLED
#define EUI_DEBUG_DESCRIPTION_ENABLED DEBUG
#endif

#pragma mark - BLOCK

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
