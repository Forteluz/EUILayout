//
//  ViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "ViewController.h"
#import "TestFactory.h"

@interface ViewController()
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    EUITemplet *templet =
        TRow(EButton(@"Template Introduction", ^{ @strongify(self); [self templateIntroduction];}),
             EButton(@"Copy Scene Case", ^{ @strongify(self); [self copySceneCase];}),
             EButton(@"Test FPS 😁", ^{ @strongify(self); [self testFPS];}),
             );
    templet.padding = EUIEdgeMake(10, 10, 10, 10);
    templet.margin.top = 20;
    
    [self.view eui_layout:templet];
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
    one.columns = 4;
    
    EUILayout *node = [self.view.eui_templet nodeAtIndex:0];
    [node.view eui_layout:one];
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
    EUILayout *node = [self.view.eui_templet nodeAtIndex:0];
    [node.view eui_cleanUp];
}

@end
