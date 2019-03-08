//
//  HMPickerDataSourceController.m
//  MiFit
//
//  Created by ddj on 15/12/2.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMPickerDataSourceController.h"
#import "HMPickerCommonCell.h"
#import "HMPickerColumnView.h"
#import "HMPickerDataSourceModel.h"

@interface HMPickerDataSourceController ()

@end

@implementation HMPickerDataSourceController

- (instancetype)initWithDelegate:(id<HMDataSourceDelegate>)delegate pickerView:(HMPickerView *)pickerView dataSourceModel:(HMPickerDataSourceModel *)dataSourceModel {
    if (self = [super init]) {
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.title = dataSourceModel.pickerViewTitle;
        self.pickerView = pickerView;
        self.delegate = delegate;
        self.dataSourceModel = dataSourceModel;
        [self updateValuesForRow:0 inComponent:0];
        [self updateValuesForRow:0 inComponent:1];
        [self updateSubclassValue];
    }
    return self;
}

- (void)updateSubclassValue {
    //Need to be overwritten in subclasses.
}

#pragma mark - HMPickerViewDataSource -

- (BOOL)useUIPickerViewInPickerView:(HMPickerView *)pickerView {
    return self.dataSourceModel.useUIPickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(HMPickerView *)pickerView {
    return self.dataSourceModel.needToShowSubUnit ? 2 : 1;
}

- (NSInteger)pickerView:(HMPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger startValue, endValue, stepValue;
    
    if (self.dataSourceModel.needToShowSubUnit && component == 1) {
        startValue = self.dataSourceModel.subUnitStartValue;
        endValue = self.dataSourceModel.subUnitEndValue;
        stepValue = self.dataSourceModel.subUnitStepValue;
    } else {
        startValue = self.dataSourceModel.startValue;
        endValue = self.dataSourceModel.endValue;
        stepValue = self.dataSourceModel.stepValue;
    }
    return [self numberOfRowsWithStartValue:startValue endValue:endValue stepValue:stepValue];
}

#pragma mark - HMPickerViewDelegate -

- (CGFloat)pickerView:(HMPickerView *)pickerView widthForComponent:(NSInteger)component {
     if (self.dataSourceModel.needToShowSubUnit && component == 1) {
         return self.dataSourceModel.rowWidthForSubUnit;
     } else {
         return self.dataSourceModel.rowWidth;
     }
}

- (NSString *)pickerView:(HMPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self valueForRow:row forComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    HMPickerCommonCell *viewForRow = [self nibName:self.dataSourceModel.nibName forPickerView:pickerView viewForComponent:component reusingView:view];
    
    NSString *string = [self valueForRow:row forComponent:component];
    viewForRow.labelTitle.textColor = self.dataSourceModel.titleAttributes[NSForegroundColorAttributeName];
    viewForRow.labelTitle.font = self.dataSourceModel.titleAttributes[NSFontAttributeName];
    viewForRow.labelTitle.text = string;
    
    return viewForRow;
}

- (CGFloat)pickerView:(HMPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.dataSourceModel.rowHeight;
}

- (NSDictionary *)attributesForPickerView:(HMPickerView *)pickerView {
    return self.dataSourceModel.titleAttributes;
}

- (void)pickerView:(HMPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateValuesForRow:row inComponent:component];
    [self notifyDelegateValueDidChanged];
}

- (UIColor *)columnSeparatorColorForPickerView:(HMPickerView *)pickerView {
    return self.dataSourceModel.columnSeparatorColor;
}

- (UIColor *)pickerView:(HMPickerView *)pickerView columnTitleColorForComponent:(NSInteger)component {
    return self.dataSourceModel.titleColor;
}

- (NSString *)pickerView:(HMPickerView *)pickerView columnTitleForComponent:(NSInteger)component {
    if (self.dataSourceModel.needToShowSubUnit && component == 1) {
        return self.dataSourceModel.subUnitTitle;
    } else {
        return self.dataSourceModel.title;
    }
}

- (CGFloat)pickerView:(HMPickerView *)pickerView columnTitleOffsetXForComponent:(NSInteger)component {
    if (self.dataSourceModel.needToShowSubUnit && component == 1) {
        return self.dataSourceModel.subUnitTitleOffsetX;
    } else {
        return self.dataSourceModel.titleOffsetX;
    }
}

- (NSDictionary *)selectedAttributesForPickerView:(HMPickerView *)pickerView {
    return self.dataSourceModel.selectedTitleAttributes;
}

#pragma mark - Public methods -

- (void)updateValuesForRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger numberOfRows = [self pickerView:self.pickerView numberOfRowsInComponent:component];
    NSInteger actualRow;
    
    if (row >= numberOfRows) {
        actualRow = numberOfRows - 1;
    } else if (row < 0) {
        actualRow = 0;
    } else {
        actualRow = row;
    }
    
    if (component == 0) {
        NSInteger value = [self integerValueForRow:actualRow forComponent:component];
        self.value = value;
    } else {
        NSInteger subUnitValue = [self integerValueForRow:actualRow forComponent:component];
        self.subUnitValue = subUnitValue;
    }
}

- (void)notifyDelegateValueDidChanged {
    if (self.delegate && [self.delegate respondsToSelector:@selector(valueOfDataSourceControllerDidChanged:)]) {
        [self.delegate valueOfDataSourceControllerDidChanged:self];
    }
}

- (NSInteger)numberOfRowsWithStartValue:(NSInteger)startValue endValue:(NSInteger)endValue stepValue:(NSInteger)stepValue {
    return (endValue - startValue) / stepValue + 1;
}

- (NSInteger)rowForIntegerValue:(NSInteger)value forComponent:(NSInteger)component {
    
    NSInteger startValue, stepValue;
    
    if (self.dataSourceModel.needToShowSubUnit && component == 1) {
        startValue = self.dataSourceModel.subUnitStartValue;
        stepValue = self.dataSourceModel.subUnitStepValue;
    } else {
        startValue = self.dataSourceModel.startValue;
        stepValue = self.dataSourceModel.stepValue;
    }
    
    NSInteger row = (value - startValue) / stepValue;
    
    return row;
}

- (NSInteger)integerValueForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSInteger startValue, stepValue;
    
    if (self.dataSourceModel.needToShowSubUnit && component == 1) {
        startValue = self.dataSourceModel.subUnitStartValue;
        stepValue = self.dataSourceModel.subUnitStepValue;
    } else {
        startValue = self.dataSourceModel.startValue;
        stepValue = self.dataSourceModel.stepValue;
    }
    
    NSInteger content = startValue + row * stepValue;
    
    return content;
}

- (NSString *)valueForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSInteger content = [self integerValueForRow:row forComponent:component];
   
    return [@(content) stringValue];
}

- (HMPickerCommonCell *)nibName:(NSString *)nibName forPickerView:(UIPickerView *)pickerView viewForComponent:(NSInteger)component reusingView:(UIView *)view {
    
    HMPickerCommonCell *viewForRow = nil;
    if (!view) {
        viewForRow = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
        CGSize size = [pickerView rowSizeForComponent:0];
        CGRect frame = viewForRow.frame;
        frame.size.height = size.height;
        frame.size.width = size.width;
        viewForRow.frame = frame;
        [viewForRow layoutIfNeeded];
    } else {
        viewForRow = (HMPickerCommonCell *)view;
    }
    return viewForRow;
}

@end
