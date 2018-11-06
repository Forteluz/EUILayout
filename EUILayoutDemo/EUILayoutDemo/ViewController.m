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
    UIView *a = EButton(@"Template Introduction", ^{ @strongify(self); [self templateIntroduction];});
    UIView *b = EButton(@"Copy Scene Case", ^{ @strongify(self); [self copySceneCase];});
    UIView *c = EButton(@"Test FPS 😁", ^{ @strongify(self); [self testFPS];});
    UIView *d = EButton(@"Test Funny", ^{ @strongify(self); [self testFunny];});
    UIView *e = EButton(@"Base Function", ^{ @strongify(self); [self baseFunction];});
    EUITemplet *one = TRow(
                           a,
                           e,
                           TColumn(b, c, d)
                           );
    [self.view eui_layout:one];
}

#pragma mark - Action

- (void)templateIntroduction {
    @weakify(self);
    EUITemplet *one =
        TColumn(EButton(@"TBase",   ^{@strongify(self) [self introduceTBase];}),
                EButton(@"TGrid",   ^{@strongify(self) [self introduceTGrid];}),
                EButton(@"TRow" ,   ^{@strongify(self) [self introduceTRow];}),
                EButton(@"TColumn", ^{@strongify(self) [self introduceTColumn];}),
                EButton(@"Close",   ^{@strongify(self) [self introduceColse];}));
    one.padding = EUIEdgeMake(10, 10, 10, 10);
    EUINode *node = [self.view eui_nodeAtIndex:0];
    [node.view eui_layout:one];
}

- (void)copySceneCase {
    EUIGoto(self, @"EUIDemoORViewController");
}

- (void)testFPS {
    EUIGoto(self, @"EUITestFPSViewController");
}

- (void)testFunny {
    EUIGoto(self, @"EUITestFunnyViewController");
}

- (void)baseFunction {
    EUIGoto(self, @"EUIBaseFunctionTestViewController");
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
    EUITemplet *templet = [self.view eui_nodeAtIndex:0];
    [templet removeAllSubnodes];
    [self.view eui_reload];
}

@end
