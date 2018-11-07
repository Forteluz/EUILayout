//
//  EUIAssert.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/11/7.
//  Copyright © 2018 Lux. All rights reserved.
//

#ifndef EUIAssert
#define EUIAssert( condition, ... ) NSCAssert( (condition) , ##__VA_ARGS__)
#endif

#ifndef EUIFailAssert
#define EUIFailAssert( ... ) EUIAssert( (NO) , ##__VA_ARGS__)
#endif

#ifndef EUIParameterAssert
#define EUIParameterAssert( condition ) EUIAssert( (condition) , @"Invalid parameter not satisfying: %@", @#condition)
#endif

#ifndef EUIAssertMainThread
#define EUIAssertMainThread() EUIAssert( ([NSThread isMainThread] == YES), @"Must be on the main thread")
#endif

