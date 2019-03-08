//
//  HMPickerCommonCell.m
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import "HMPickerCommonCell.h"
#import "HMDesignTools.h"

@implementation HMPickerCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    self.backgroundColor = [UIColor redColor];
//    self.labelTitle.backgroundColor = [UIColor greenColor];
    
    self.labelTitleRightConstraint.constant = [HMDesignTools designScaleValueWithOriginalValue:64];
}

@end
