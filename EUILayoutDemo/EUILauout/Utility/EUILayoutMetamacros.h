//
//  EUILayoutMetamacros.h
//  EUILayoutDemo
//
//  Created by Lux on 2018/9/25.
//  Copyright © 2018年 Lux. All rights reserved.
//

#ifndef EUILayoutMetamacros_h
#define EUILayoutMetamacros_h

#pragma mark -

#define YOGA_UPDATE_INSERTS(layout, pre , edge)                         \
    if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, edge)) {       \
        layout.pre##Left   = YGPointValue(edge.left);                   \
        layout.pre##Right  = YGPointValue(edge.right);                  \
        layout.pre##Top    = YGPointValue(edge.top);                    \
        layout.pre##Bottom = YGPointValue(edge.bottom);                 \
    }

#define YOGASetPadding(layout, edge) YOGA_UPDATE_INSERTS(layout, padding, edge)
#define YOGASetMargin(layout, edge) YOGA_UPDATE_INSERTS(layout, margin, edge)

#pragma mark -

#define NODE_VALID_WIDTH(_NODE_) _NODE_BASED_VALUE_METHOD(_NODE_, width)
#define NODE_VALID_HEIGHT(_NODE_) _NODE_BASED_VALUE_METHOD(_NODE_, height)
#define _NODE_BASED_VALUE_METHOD(_NODE_, _METHOD_)           \
        _NODE_.size._METHOD_ > 0 ? _NODE_.size._METHOD_ :    \
        _NODE_.view.bounds.size._METHOD_ ? _NODE_.view.bounds.size._METHOD_ : 0

#pragma mark -

#define NODE_RL_EDGE(_NODE_) (NODE_RL_EDGE_METHOD(_NODE_, margin) + NODE_RL_EDGE_METHOD(_NODE_, padding))
#define NODE_RL_EDGE_METHOD(_NODE_, _METHOD_) (_NODE_._METHOD_.left + _NODE_._METHOD_.right)

#define NODE_TB_EDGE(_NODE_) (_NODE_SIDE_EDGE_METHOD(_NODE_, margin) + _NODE_SIDE_EDGE_METHOD(_NODE_, padding))
#define NODE_TB_EDGE_METHOD(_NODE_, _METHOD_) (_NODE_._METHOD_.top + _NODE_._METHOD_.bottom)

#pragma mark -

#define YOGA_VALID_WIDTH(_VIEW_) _VIEW_.bounds.size.width ?: _VIEW_.yoga.width.value
#define YOGA_VALID_HEIGHT(_VIEW_) _VIEW_.bounds.size.height ?: _VIEW_.yoga.height.value

#pragma mark -

#define RGBCOLOR(r, g, b)     [UIColor colorWithRed: (r) / 255.0f green: (g) / 255.0f blue: (b) / 255.0f alpha : 1]
#define DCRandomColor RGBCOLOR(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* EUILayoutMetamacros_h */
