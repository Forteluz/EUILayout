//
//  XYWHMan.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/15.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUINode.h"
#import "EUIXParser.h"
#import "EUIYParser.h"
#import "EUIWParser.h"
#import "EUIHParser.h"
#import "EUIParsing.h"

NS_ASSUME_NONNULL_BEGIN

@interface EUIParser : NSObject <EUIParsing>
@property (nonatomic, strong) EUIXParser *xMan;
@property (nonatomic, strong) EUIYParser *yMan;
@property (nonatomic, strong) EUIWParser *wMan;
@property (nonatomic, strong) EUIHParser *hMan;
@property (nonatomic, copy) EUIParsingHandler parsingBlock;
@end

NS_ASSUME_NONNULL_END
