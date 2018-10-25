//
//  EUITestFPSTableViewCell.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EUITestTopCard.h"
#import "EUITestMidCard.h"
#import "EUITestBottomCard.h"

@interface EUITestFPSTableViewCell : UITableViewCell
@property (nonatomic, strong) EUITestTopCard *topCard;
@property (nonatomic, strong) EUITestMidCard *midCard;
@property (nonatomic, strong) EUITestBottomCard *bottomCard;

- (void)updateWithModel:(id)model;

+ (CGFloat)cellHeight:(id)model;


@end

