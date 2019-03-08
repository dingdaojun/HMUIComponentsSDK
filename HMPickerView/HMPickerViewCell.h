//
//  HMPickerViewCell.h
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import <UIKit/UIKit.h>

@class DjuPickerView;
@class HMUIPickerView;
@interface HMPickerViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (strong, nonatomic) DjuPickerView *pickerView;
@property (weak, nonatomic) IBOutlet HMUIPickerView *uiPickerView;
@property (assign, nonatomic) NSInteger component;

@end
