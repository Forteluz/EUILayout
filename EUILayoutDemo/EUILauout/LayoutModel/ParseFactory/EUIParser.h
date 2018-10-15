//
//  XYWHMan.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIParsing.h"

#ifndef EUIParserClass
#define EUIParserClass(_CLS_) \
    @interface _CLS_ : NSObject <EUIParsing> \
    @property (nonatomic, copy) EUIParsingHandler parsingBlock; \
    @end
#endif

NS_ASSUME_NONNULL_BEGIN

EUIParserClass(EUIXParser);
EUIParserClass(EUIYParser);
EUIParserClass(EUIWParser);
EUIParserClass(EUIHParser);

@interface EUIParser : NSObject <EUIParsing>
@property (nonatomic, strong) EUIXParser *xParser;
@property (nonatomic, strong) EUIYParser *yParser;
@property (nonatomic, strong) EUIWParser *wParser;
@property (nonatomic, strong) EUIHParser *hParser;
@property (nonatomic, copy) EUIParsingHandler parsingBlock;
@end

NS_ASSUME_NONNULL_END
