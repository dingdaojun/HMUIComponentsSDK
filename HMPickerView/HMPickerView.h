//
//  HMPickerView.h
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: dingdaojun(dingdaojun@huami.com)
// 

#import <UIKit/UIKit.h>
#import "DjuPickerView.h"
#import "HMPickerColumnView.h"

@class HMPickerViewCell;

@protocol HMPickerViewDelegate;
@protocol HMPickerViewDataSource;
@interface HMPickerView : UIView

@property(weak, nonatomic) id<HMPickerViewDelegate> delegate;
@property(weak, nonatomic) id<HMPickerViewDataSource> dataSource;
@property(strong, nonatomic) HMPickerColumnView *leftPickerColumnView;
@property(strong, nonatomic) HMPickerColumnView *rightPickerColumnView;
@property(strong, nonatomic) NSString *title;
/*
 交换左右 UIPickerView 的显示次序
 比如, 德语环境下的出生日期, 左边显示年份, 右侧显示月份
 由于显示的数据和计算的数据必须一致, 所以在此直接修改显示次序代价最小.
 ! 交换实际的 IndexPath 和 UIPickerView实际保存的 indexPath
 例如: 实际是item 0 section 0, 那么 UIPickerView 保存的是 item 1 section 0
*/
@property(assign, nonatomic) BOOL needExchangeComponent;

- (void)reloadAllComponents;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end

@interface DjuPickerView (IndexPath)

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@interface UIPickerView (IndexPath)

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@protocol HMPickerViewDataSource<NSObject>

@required
- (BOOL)useUIPickerViewInPickerView:(HMPickerView *)pickerView;

- (NSInteger)numberOfComponentsInPickerView:(HMPickerView *)pickerView;

- (NSInteger)pickerView:(HMPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@protocol HMPickerViewDelegate<NSObject>

@optional
- (UIColor *)columnSeparatorColorForPickerView:(HMPickerView *)pickerView;
- (UIColor *)pickerView:(HMPickerView *)pickerView columnTitleColorForComponent:(NSInteger)component;
- (NSString *)pickerView:(HMPickerView *)pickerView columnTitleForComponent:(NSInteger)component;
- (CGFloat)pickerView:(HMPickerView *)pickerView columnTitleOffsetXForComponent:(NSInteger)component;

- (NSDictionary *)attributesForPickerView:(HMPickerView *)pickerView;
- (NSDictionary *)selectedAttributesForPickerView:(HMPickerView *)pickerView;

- (CGFloat)pickerView:(HMPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(HMPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (NSString *)pickerView:(HMPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)pickerView:(HMPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (UIView *)pickerView:(HMPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;

@end
