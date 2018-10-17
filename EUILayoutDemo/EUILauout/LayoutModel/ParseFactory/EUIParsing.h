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

typedef enum : unsigned short {
    EUIParsedNone  = 0,
    EUIParsedStepX = 1 << 0,
    EUIParsedStepY = 1 << 1,
    EUIParsedStepW = 1 << 2,
    EUIParsedStepH = 1 << 3,
    EUIParsedStepDone = 0x00F
} EUIParsedStep;

typedef struct {
    CGRect frame;
    EUIParsedStep step;
    BOOL recalculate;
    CGSize constraintSize;
} EUIParseContext;

typedef void (^EUIParsingHandler) (EUINode *node,
                                   EUINode *_Nullable preNode,
                                   EUIParseContext *context);

@protocol EUIParsing <NSObject>

- (void)parse:(EUINode *)layout
            _:(EUINode *_Nullable)preLayout
            _:(EUIParseContext *)context;

@end


#endif /* EUIParsing_h */
