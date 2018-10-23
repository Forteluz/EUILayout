//
//  XYWHMan.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIParsing.h"

#ifndef EUI_INTERFACE_CLASS
#define EUI_INTERFACE_CLASS(_NAME_) \
    @interface _NAME_ : NSObject <EUIParsing> \
    @property (nonatomic, copy, nullable) EUIParsingHandler parsingBlock; \
    @end
#endif

NS_ASSUME_NONNULL_BEGIN

EUI_INTERFACE_CLASS(EUIXParser);
EUI_INTERFACE_CLASS(EUIYParser);
EUI_INTERFACE_CLASS(EUIWParser);
EUI_INTERFACE_CLASS(EUIHParser);

@interface EUIParser : NSObject <EUIParsing>
@property (nonatomic, strong) EUIXParser *xParser;
@property (nonatomic, strong) EUIYParser *yParser;
@property (nonatomic, strong) EUIWParser *wParser;
@property (nonatomic, strong) EUIHParser *hParser;
@property (nonatomic, copy, nullable) EUIParsingHandler parsingBlock;
@end

NS_ASSUME_NONNULL_END
