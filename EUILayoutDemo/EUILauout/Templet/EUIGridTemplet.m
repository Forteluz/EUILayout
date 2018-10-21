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

@implementation EUIGridTemplet

- (instancetype)initWithItems:(NSArray<EUIObject> *)items {
    self = [super initWithItems:items];
    if (self) {
        
    }
    return self;
}

- (void)layoutWillStart {
    [super layoutWillStart];

    if (self.columns == 0 && self.rows == 0) {
        self.columns  = 3;
    }
    if (self.columns == 0) {
        self.columns = ceil(self.nodes.count / self.rows);
    } else if (self.rows == 0) {
        self.rows = ceil(self.nodes.count / self.columns) + 1;
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
    
    [self removeAllNodes];
    [self addNode:row];
}

@end
