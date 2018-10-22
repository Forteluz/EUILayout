//
//  EUIGridTemplet.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/22.
//  Copyright © 2018 Lux. All rights reserved.
//

#import "EUIGridTemplet.h"
#import "EUIRowTemplet.h"
#import "EUIColumnTemplet.h"

@interface EUIGridTemplet()
@property (copy, readwrite) NSArray <EUINode *> *nodes;
@end
@implementation EUIGridTemplet
@dynamic nodes;

- (void)layoutWillStart {
    [super layoutWillStart];
    
    if (self.nodes.count == 0) {
        return;
    }

    ///< 从别的库学个 Grid 用
    if (self.columns == 0 && self.rows == 0) {
        self.columns  = 3;
    }
    if (self.columns == 0) {
        self.columns = ceil(self.nodes.count / (double)self.rows);
    } else if (self.rows == 0) {
        self.rows = ceil(self.nodes.count / (double)self.columns);
    }
    
    NSArray <EUINode *> *nodes = self.nodes;
    NSInteger n = 0;

    EUITemplet *row = TRow(@"");
    for (NSInteger i = 0; i < self.rows; i++) {
        EUITemplet *column = TColumn(@"");
        for (NSInteger j = 0; j < self.columns; j++) {
            if (n >= nodes.count) {
                break;
            }
            EUINode *node = [nodes objectAtIndex:n];
            [column addNode:node];
            n++;
        }
        [row addNode:column];
    }
    self.nodes = @[row];
}

@end
