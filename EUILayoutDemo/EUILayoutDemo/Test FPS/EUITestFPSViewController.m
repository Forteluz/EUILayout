//
//  EUITestFPSViewController.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/24.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITestFPSViewController.h"
#import "EUITestFPSTableViewCell.h"
#import "EUILayoutKit.h"
#import "TestFactory.h"
#import <JPFPSStatus/JPFPSStatus.h>

@interface EUITestFPSViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EUITestFPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self.tableView reloadData];
}

- (void)setupSubviews {
    @weakify(self)
    UIButton *back = EButton(@"BACK", ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:NULL];
    });
    UILabel *label = EText(@"FPS");
    [JPFPSStatus sharedInstance].fpsLabel = label;
    
    EUITemplet *one = TRow([TColumn(back, label)
                            configure:^(EUILayout *layout) {
                                    layout.maxHeight = 44;
                           }],
                           self.tableView);
    one.margin = EUIEdgeMake(20, 10, 10, 10);
    [self.view eui_layout:one];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [EUITestFPSTableViewCell cellHeight:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EUITestFPSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EUITestFPSTableViewCell"];
    [cell updateWithModel:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor redColor];
        [_tableView registerClass:EUITestFPSTableViewCell.class forCellReuseIdentifier:@"EUITestFPSTableViewCell"];
    }
    return _tableView;
}

@end
