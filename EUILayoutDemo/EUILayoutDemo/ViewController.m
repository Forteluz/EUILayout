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
    TRow(EButton(@"Template Introduction", ^{ @strongify(self); [self templateIntroduction]; }),
         EButton(@"Copy Scene Case", ^{ @strongify(self); [self copySceneCase]; }),
         EButton(@"Test FPS", ^{ @strongify(self); [self testFPS]; }),
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
              EButton(@"Back",    ^{@strongify(self) [self introduceColse];}));
    one.columns = 4;
    EUINode *node = [self.view.eui_templet nodeAtIndex:0];
    [UIView animateWithDuration:0.25 animations:^{
        [node.view eui_update:one];
    }];
}

- (void)copySceneCase {
    
}

- (void)testFPS {
    
}

#pragma mark - Introduce Templet

- (void)introduceTBase {}
- (void)introduceTGrid {}
- (void)introduceTRow {}
- (void)introduceTColumn {}
- (void)introduceColse {
    
}

@end
