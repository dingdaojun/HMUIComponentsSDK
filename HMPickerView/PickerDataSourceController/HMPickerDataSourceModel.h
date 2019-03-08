//
//  HMPickerDataSourceModel.h
//  MiFit
//
//  Created by dingdaojun on 15/12/7.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMPickerDataSourceModel : NSObject

@property (nonatomic, assign) BOOL useUIPickerView;

@property (nonatomic, strong) NSString *pickerViewTitle;

@property (nonatomic, assign) NSInteger startValue;
@property (nonatomic, assign) NSInteger endValue;
@property (nonatomic, assign) NSInteger stepValue;
@property (nonatomic, assign) BOOL needToShowSubUnit;
@property (nonatomic, assign) NSInteger subUnitStartValue;
@property (nonatomic, assign) NSInteger subUnitEndValue;
@property (nonatomic, assign) NSInteger subUnitStepValue;

@property (nonatomic, strong) NSString *subUnitTitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *columnSeparatorColor;

@property (nonatomic, assign) CGFloat titleOffsetX;
@property (nonatomic, assign) CGFloat subUnitTitleOffsetX;

@property (nonatomic, strong) NSString *nibName;
@property (nonatomic, strong) NSString *columnNibName;
@property (nonatomic, assign) NSInteger rowWidth;
@property (nonatomic, assign) NSInteger rowWidthForSubUnit;
@property (nonatomic, assign) NSInteger rowHeight;

@property (nonatomic, copy) NSDictionary *titleAttributes;
@property (nonatomic, copy) NSDictionary *selectedTitleAttributes;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) NSInteger selectedSubUnitRow;

- (instancetype)initForDefault;
- (instancetype)initForActionSheet;

- (instancetype)initForWhiteBackground;

- (void)initialize;

- (void)configureSubUnitProperties;
- (void)configureSubUnitPropertiesForActionSheet;

@end
