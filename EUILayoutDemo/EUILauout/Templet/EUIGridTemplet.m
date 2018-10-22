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

    ///< 从其他布局库学个 Grid 用
    if (self.columns == 0 && self.rows == 0) {
        self.columns  = 3;
    }
    NSInteger count = self.nodes.count;
    if (self.columns == 0) {
        self.columns = ceil(count / self.rows);
    } else if (self.rows == 0) {
        NSInteger n = ceil(count / self.columns);
        if (n == 0) {
            n =  1;
        } else if ((self.nodes.count % self.columns) > 0) {
            n += 1;
        }
        self.rows = n;
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
