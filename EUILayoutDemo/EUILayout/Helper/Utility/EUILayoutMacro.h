//
//  EUILayoutMarco.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#ifndef EUILayoutMarco_h
#define EUILayoutMarco_h

#pragma mark - For Node

#define NODE_VALID_SIZE(_NODE_) CGSizeMake(NODE_VALID_WIDTH(_NODE_),NODE_VALID_HEIGHT(_NODE_))
#define NODE_VALID_WIDTH(_NODE_) _NODE_BASED_VALUE_METHOD(_NODE_, width)
#define NODE_VALID_HEIGHT(_NODE_) _NODE_BASED_VALUE_METHOD(_NODE_, height)
#define _NODE_BASED_VALUE_METHOD(_NODE_, _METHOD_) \
        ( _NODE_.size._METHOD_ > 0 && _NODE_.size._METHOD_ != NSNotFound \
        ? _NODE_.size._METHOD_ : _NODE_.view.bounds.size._METHOD_ > 0 && _NODE_.view.bounds.size._METHOD_ != NSNotFound \
        ? _NODE_.view.bounds.size._METHOD_ : 0 )

#define NODE_RL_EDGE(_NODE_) (NODE_RL_EDGE_METHOD(_NODE_, margin) + NODE_RL_EDGE_METHOD(_NODE_, padding))
#define NODE_RL_EDGE_METHOD(_NODE_, _METHOD_) (_NODE_._METHOD_.left + _NODE_._METHOD_.right)

#define NODE_TB_EDGE(_NODE_) (_NODE_SIDE_EDGE_METHOD(_NODE_, margin) + _NODE_SIDE_EDGE_METHOD(_NODE_, padding))
#define NODE_TB_EDGE_METHOD(_NODE_, _METHOD_) (_NODE_._METHOD_.top + _NODE_._METHOD_.bottom)

#pragma mark -

#define EUIUpdateGravity(_LAYOUT_,_METHOD_) \
    if (!((_LAYOUT_.gravity) & \
        (EUIGravity##_METHOD_##Start | EUIGravity##_METHOD_##Center | EUIGravity##_METHOD_##End))) {\
        _LAYOUT_.gravity |= EUIGravity##_METHOD_##Start;\
    }

#define EUIUpdateSizeType(_LAYOUT_, _METHOD_) \
    if (!(_LAYOUT_.sizeType & (EUISizeTypeTo##_METHOD_##Fill | EUISizeTypeTo##_METHOD_##Fit))) { \
        EUISizeType type = self.sizeType & (EUISizeTypeTo##_METHOD_##Fill | EUISizeTypeTo##_METHOD_##Fit); \
        if (type != EUISizeTypeNone) { \
            _LAYOUT_.sizeType |= type; \
        } else { \
            _LAYOUT_.sizeType |= EUISizeTypeTo##_METHOD_##Fill; \
        } \
    }

#pragma mark -

#ifndef EUI_CLAMP
#define EUI_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#define EUIAfter(_QUEUE_, _SEC_ , _BLOCK_) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_SEC_ * NSEC_PER_SEC)), _QUEUE_, _BLOCK_)

#define EUIKeyPath(_OBJ_,_KEYPATH_) @(((void)_OBJ_._KEYPATH_,#_KEYPATH_))

#pragma mark - For Test

#define EUIAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define EUIColor(r, g, b) [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha : 1]
#define EUIRandomColor EUIColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#pragma mark - For Block

#define EUI_LOG 1

#ifndef onExit
#define onExit \
__strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^
#endif

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

#endif /* EUILayoutMarco_h */
