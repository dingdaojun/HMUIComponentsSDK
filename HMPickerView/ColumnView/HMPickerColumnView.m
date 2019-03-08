//
//  HMPickerColumnView.m
//  MiFit
//
//  Created by dingdaojun on 15/12/7.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMPickerColumnView.h"
#import "HMDesignTools.h"

@implementation HMPickerColumnView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    
    self.topLineHeightConstraint.constant = HMDesignTools.designPixelSize;
    self.bottomLineHeightConstraint.constant = HMDesignTools.designPixelSize;
}

- (void)setColumnSeparatorColor:(UIColor *)color {
    self.topLineView.backgroundColor = color;
    self.bottomLineView.backgroundColor = color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
