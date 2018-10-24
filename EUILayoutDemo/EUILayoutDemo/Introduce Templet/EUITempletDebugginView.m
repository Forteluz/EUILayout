//
//  EUITempletDebugginView.m
//  EUILayoutDemo
//
//  Created by Lux on 2018/10/23.
//  Copyright © 2018年 Lux. All rights reserved.
//

#import "EUITempletDebugginView.h"
#import "TestFactory.h"
#import "EUILayoutKit.h"

@implementation EUITempletDebugginView
{
    UIButton *_gravityBtn;
    UIButton *_sizeTpBtn;
    UIButton *_frameBtn;
    UIButton *_edgeBtn;
    UIButton *_addBtn;
    UIButton *_delBtn;
    UIButton *_insertBtn;
    
    NSInteger _controlIndex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        @weakify(self);
        _gravityBtn = EButton(@"GRAVITY", ^{
            @strongify(self); [self randomGravity];
        });
        _sizeTpBtn = EButton(@"SIZETYPE", ^{
            @strongify(self); [self randomSizeType];
        });
        _frameBtn = EButton(@"FRAME", ^{
            @strongify(self); [self randomFrame];
        });
        _edgeBtn = EButton(@"EDGE", ^{
            @strongify(self); [self randomEdge];
        });
        _addBtn = EButton(@"ADD", ^{
            @strongify(self); [self randomAdd];
        });
        _delBtn = EButton(@"DELETE", ^{
            @strongify(self); [self randomDel];
        });
        _insertBtn = EButton(@"INSERT", ^{
            @strongify(self); [self randomInsert];
        });
        
        _controlIndex = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    ///< Not Perty..., but clear!
    EUITemplet *one = TRow(_gravityBtn,
                           _sizeTpBtn,
                           TColumn(_frameBtn, _edgeBtn),
                           TColumn(_addBtn, _delBtn, _insertBtn));
    [self eui_layout:one];
}

- (void)randomGravity {
    static int lastGravityN = 1;
    if (lastGravityN > 3) {
        lastGravityN = 1;
    }
    int i = EUIRandom(2, 3);
    UIView *one = nil;
    if (i == 1) {
        one = self;
    } else if (i == 2) {
        one = (UIButton *)[self eui_viewWithTag:_controlIndex - 1];
    } else {
        one = _edgeBtn;
    }
    switch (lastGravityN) {
        case 1:{
            one.eui_gravity = EUIGravityHorzCenter | EUIGravityVertCenter;
        } break;
        case 2:{
            one.eui_gravity = EUIGravityHorzStart | EUIGravityVertCenter;
        } break;
        case 3:{
            one.eui_gravity = EUIGravityHorzEnd | EUIGravityVertEnd;
        } break;
    }
    if (one == self) {
        ///< 作为子模板修改自己的gravity 或者 sizetype 属性后，需要父 templet 刷新
        ///< TODO : 如何快速找到父模板?
        EUITemplet *one = self.superview.eui_engine.rootTemplet;
        [one layout];
    } else {
        [self eui_reload];
    }
    lastGravityN ++;
}

- (void)randomSizeType {
    static int lastSizeTypeN = 1;
    if (lastSizeTypeN > 4) {
        lastSizeTypeN = 1;
    }
    UIButton *one = (UIButton *)[self eui_viewWithTag:_controlIndex - 1];
    EUILayout *node = one.eui_layout;
    switch (lastSizeTypeN) {
        case 1:node.sizeType = EUISizeTypeToFit;
            [one setTitle:@"sizeType : EUISizeTypeToFit" forState:UIControlStateNormal];
            break;
        case 2:node.sizeType = EUISizeTypeToFill;
            [one setTitle:@"sizeType : EUISizeTypeToFill" forState:UIControlStateNormal];
            break;
        case 3:node.sizeType = EUISizeTypeToVertFit | EUISizeTypeToHorzFill;
            [one setTitle:@"sizeType : EUISizeTypeToVertFit \n | EUISizeTypeToHorzFill" forState:UIControlStateNormal];
            break;
        case 4:node.sizeType = EUISizeTypeToHorzFit | EUISizeTypeToVertFill;
            [one setTitle:@"sizeType : EUISizeTypeToHorzFit \n | EUISizeTypeToVertFill" forState:UIControlStateNormal];
            break;
    }
    [self eui_reload];
    lastSizeTypeN ++;
}

- (void)randomFrame {
    static int lastFrameN = 1;
    if (lastFrameN > 3) {
        lastFrameN = 1;
    }
    CGRect r = self.frame;
    if (lastFrameN == 1) {
        r.size = CGSizeMake(200, 200);
    } else if (lastFrameN == 2) {
        r = CGRectMake(100, 40, self.superview.bounds.size.width - 100 - 10, 100);
        self.eui_frame = (CGRect) {.size = r.size};
    } else {
        r = self.superview.bounds;
    }
    self.frame = r;
    lastFrameN ++;
}

- (void)randomEdge {
    static int edgeLastN = 1;
    if (edgeLastN > 4) {
        edgeLastN = 1;
    }
    switch (edgeLastN) {
        case 1: {
            if (self.eui_padding.top == 20) {
                self.eui_padding = EUIEdge.edgeZero;
            } else {
                self.eui_padding = EUIEdgeMake(20, 10, 10, 10);
            }
        }break;
        case 2: {
            if (_edgeBtn.eui_margin.top == 10) {
                _edgeBtn.eui_margin = EUIEdge.edgeZero;
            } else {
                _edgeBtn.eui_margin = EUIEdgeMake(10, 10, 10, 10);
            }
        }break;
        case 3: {
            if (_edgeBtn.eui_templet.padding.top == 10) {
                _edgeBtn.eui_templet.padding = EUIEdge.edgeZero;
            } else {
                _edgeBtn.eui_templet.padding = EUIEdgeMake(10, 10, 10, 10);
            }
        }break;
        case 4: {
            UIView *one = [self eui_viewWithTag:_controlIndex - 1];
            if (one.eui_margin.top == 10) {
                one.eui_margin = EUIEdge.edgeZero;
            } else {
                one.eui_margin = EUIEdgeMake(10, 10, 10, 10);
            }
        }break;
    }
    [self eui_reload];
    edgeLastN ++;
}

- (void)randomAdd {
    UIButton *one = EButton
        ([NSString stringWithFormat:@"I'm %ld", (long)_controlIndex], ^{
            
        });
    [one setTag:_controlIndex];
    [self.eui_templet addLayout:one];
    [self eui_reload];
    _controlIndex ++;
}

- (void)randomDel {
    if (_controlIndex < 2) {
        return;
    }
    UIView *one = [self eui_viewWithTag:_controlIndex - 1];
    [self.eui_templet removeLayout:one];
    [self eui_reload];
    
    _controlIndex = MAX(1, --_controlIndex);
}

- (void)randomInsert {
    UIButton *one = EButton
    ([NSString stringWithFormat:@"I'm %ld", (long)_controlIndex], ^{
        
    });
    [one setTag:_controlIndex];
    
    NSInteger n = EUIRandom(0, (int)self.eui_templet.nodes.count + 1);
    [self.eui_templet insertLayout:one atIndex:n];
    [self eui_reload];
    _controlIndex ++;
}

@end
