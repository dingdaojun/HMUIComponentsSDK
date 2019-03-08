//
//  HMPickerDataSourceController.h
//  MiFit
//
//  Created by ddj on 15/12/2.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMPickerView.h"

@class HMPickerCommonCell;
@class HMPickerDataSourceModel;
@protocol HMDataSourceDelegate;
@interface HMPickerDataSourceController : NSObject <HMPickerViewDataSource, HMPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) HMPickerDataSourceModel *dataSourceModel;

@property (nonatomic, weak) id<HMDataSourceDelegate> delegate;
@property (nonatomic, strong) HMPickerView *pickerView;

@property (nonatomic, copy) NSDictionary *titleAttributes;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger subUnitValue;

@property (nonatomic, strong) id subclassCustomValue;

- (instancetype)initWithDelegate:(id<HMDataSourceDelegate>)delegate pickerView:(HMPickerView *)pickerView dataSourceModel:(HMPickerDataSourceModel *)dataSourceModel;

- (NSInteger)numberOfRowsWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue stepValue:(NSInteger)stepValue;

- (NSString *)valueForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSInteger)integerValueForRow:(NSInteger)row forComponent:(NSInteger)component;

- (NSInteger)rowForIntegerValue:(NSInteger)value forComponent:(NSInteger)component;

- (void)updateValuesForRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)notifyDelegateValueDidChanged;

- (void)updateSubclassValue;
    
@end

@protocol HMDataSourceDelegate <NSObject>

@optional
- (void)valueOfDataSourceControllerDidChanged:(HMPickerDataSourceController *)dataSourceController;

@end
