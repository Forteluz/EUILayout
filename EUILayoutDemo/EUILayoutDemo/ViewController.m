//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "TestFactory.h"

@interface ViewController() <EUILayoutDelegate>
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view eui_setDelegate:self];
    [self.view eui_reload];
}

#pragma mark - EUILayouterDataSource

- (EUITemplet *)templetWithLayout:(EUILayout *)layout {
    @weakify(self);
    EUITemplet *templet =
    TRow(EButton(@"Template Introduction", ^{ @strongify(self); [self templateIntroduction];}),
         EButton(@"Copy Scene Case", ^{ @strongify(self); [self copySceneCase];}),
         EButton(@"Test FPS 😁", ^{ @strongify(self); [self testFPS];}),
         );
    templet.padding = EUIEdgeMake(10, 10, 10, 10);
    templet.margin.top = 20;
    return templet;
}

#pragma mark - Action

- (void)templateIntroduction {
    @weakify(self);
    EUIGridTemplet *one =
        TGrid(EButton(@"TBase",   ^{@strongify(self) [self introduceTBase];}),
              EButton(@"TGrid",   ^{@strongify(self) [self introduceTGrid];}),
              EButton(@"TRow" ,   ^{@strongify(self) [self introduceTRow];}),
              EButton(@"TColumn", ^{@strongify(self) [self introduceTColumn];}),
              EButton(@"Close",   ^{@strongify(self) [self introduceColse];}));

    EUINode *node = [self.view.eui_templet nodeAtIndex:0];
    [node.view eui_update:[one configure:^(EUIGridTemplet *grid) {
        grid.columns = 4;
    }]];
    
    // or like this, whatever...
    /*
     [one setColumns:4];
     [node.view eui_update:one];
     */
}

- (void)copySceneCase {
    
}

- (void)testFPS {
    
}

#pragma mark - Introduce Templet

- (void)introduceTBase {
    EUIGoto(self, @"EUITBaseIntroViewController");
}

- (void)introduceTGrid {
    EUIGoto(self, @"EUITGridIntroViewController");
}

- (void)introduceTRow {
    EUIGoto(self, @"EUITRowIntroViewController");
}

- (void)introduceTColumn {
    EUIGoto(self, @"EUITColumnIntroViewController");
}

- (void)introduceColse {
    ///< 目前正常的 index 查询不适用于 grid
}

@end
