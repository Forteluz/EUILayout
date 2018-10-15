//
//  EUIParsing.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#ifndef EUIParsing_h
#define EUIParsing_h

#import "EUINode.h"

typedef void (^EUIParsingHandler) (EUINode *node, EUINode *preNode, EUICalculatStatus *context);

@protocol EUIParsing <NSObject>

///< 解析器
- (void)parse:(EUINode *)layout
            _:(EUINode *_Nullable)preLayout
            _:(EUICalculatStatus *)context;

@end


#endif /* EUIParsing_h */
