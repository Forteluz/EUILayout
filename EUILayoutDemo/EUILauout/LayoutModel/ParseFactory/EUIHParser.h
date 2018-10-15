//
//  EUIHMan.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUIParsing.h"

NS_ASSUME_NONNULL_BEGIN

@interface EUIHParser : NSObject <EUIParsing>
@property (nonatomic, copy) EUIParsingHandler parsingBlock;
@end

NS_ASSUME_NONNULL_END
