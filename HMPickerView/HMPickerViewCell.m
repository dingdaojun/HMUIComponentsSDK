//
//  HMPickerViewCell.m
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

@import HMCategory.UIView_HMXib;
#import "HMPickerViewCell.h"
#import "HMPickerView.h"

@implementation HMPickerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *pickerViewToAdd = [[DjuPickerView alloc] initWithFrame:self.pickerViewContainer.bounds];
    self.pickerView = (DjuPickerView *)[self.pickerViewContainer addSubviewToFillContent:pickerViewToAdd];
}

@end
