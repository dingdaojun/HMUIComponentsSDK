//
//  HMUIPickerView.h
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import <UIKit/UIKit.h>

@protocol HMUIPickerViewDelegate;

@interface HMUIPickerView : UIPickerView

@property (weak, nonatomic) id<HMUIPickerViewDelegate> hmDelegate;

@end

@protocol HMUIPickerViewDelegate <NSObject>

- (NSDictionary *)selectedAttributesForPickerView:(HMUIPickerView *)pickerView;

@end

@interface UIPickerView (HMUIPickerView) <UITableViewDataSource>

@end
