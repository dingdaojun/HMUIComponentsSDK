//
//  HMPickerDataSourceModel.m
//  MiFit
//
//  Created by dingdaojun on 15/12/7.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMPickerDataSourceModel.h"
#import "UIColor+HMPickerDesignColors.h"
#import "NSDictionary+HMPickerAttributes.h"
@import HMCategory;
#import "UIColor+HMCommonColors.h"

@implementation HMPickerDataSourceModel

- (instancetype)initForDefault {
    
    if (self = [super init]) {
        self.rowHeight = 58;
        self.useUIPickerView = NO;
        self.titleAttributes = [NSDictionary attributesForSettingGuidePickerView];
        self.selectedTitleAttributes = [NSDictionary attributesForSettingGuidePickerViewSelected];
        self.titleColor = [UIColor whiteColorWithAlpha:0.5];
        self.columnSeparatorColor = [UIColor whiteColorWithAlpha:0.2];
        
        [self initialize];
        
        [self configureSubUnitProperties];
        [self configureSubUnitPropertiesForDefault];
    }
    return self;
}

- (instancetype)initForWhiteBackground {
    
    if (self = [self initForDefault]) {
        self.titleAttributes = [NSDictionary attributesForWhiteBackgroundPickerView];
        self.selectedTitleAttributes = [NSDictionary attributesForWhiteBackgroundPickerViewSelected];
        self.titleColor = [UIColor hmWhiteBackgroundPickerSelectedColor];
        self.columnSeparatorColor = [UIColor blackColorWithAlpha:0.2];
    }
    return self;
}

- (instancetype)initForActionSheet {
    
    if (self = [self initForDefault]) {
        self.rowHeight = 50;
        self.useUIPickerView = YES;
        self.titleAttributes = [NSDictionary attributesForActionSheetPickerView];
        self.selectedTitleAttributes = [NSDictionary attributesForActionSheetPickerViewSelected];
        
        [self initialize];
        
        [self configureSubUnitProperties];
        [self configureSubUnitPropertiesForActionSheet];
    }
    return self;
}

- (void)initialize {
    self.stepValue = 1;
    self.subUnitStepValue = 1;
    self.needToShowSubUnit = NO;
}

- (void)configureSubUnitPropertiesForDefault {
    if (self.needToShowSubUnit) {
        self.rowWidth = [UIDevice screenWidth] * 0.5;
        self.rowWidthForSubUnit = [UIDevice screenWidth] * 0.5;
        self.nibName = @"HMPickerSingleComponentCell";
        self.columnNibName = @"HMPickerSingleColumnView";
    } else {
        self.rowWidth = [UIDevice screenWidth];
        self.nibName = @"HMPickerSingleComponentCell";
        self.columnNibName = @"HMPickerSingleColumnView";
    }
}

- (void)configureSubUnitPropertiesForActionSheet {
    if (self.needToShowSubUnit) {
        self.rowWidth = [UIDevice screenWidth] * 0.5;
        self.rowWidthForSubUnit = [UIDevice screenWidth] * 0.5;
        self.nibName = @"HMActionSheetPickerSingleComponentCell";
        self.columnNibName = @"HMActionSheetPickerSingleColumnView";
    } else {
        self.rowWidth = [UIDevice screenWidth];
        self.nibName = @"HMActionSheetPickerSingleComponentCell";
        self.columnNibName = @"HMActionSheetPickerSingleColumnView";
    }
}

- (void)configureSubUnitProperties {

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[@(self.endValue) stringValue] attributes:self.titleAttributes];
    
    self.titleOffsetX = [attributedString boundingRectWithSize:CGSizeMake(self.rowWidth, self.rowHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width / 2 - 16;
    if (self.titleOffsetX < 20) {
        self.titleOffsetX = 20;
    }

    if (self.needToShowSubUnit) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[@(self.subUnitEndValue) stringValue] attributes:self.titleAttributes];
        
        self.subUnitTitleOffsetX = ceilf([attributedString boundingRectWithSize:CGSizeMake(self.rowWidth, self.rowHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width / 2) + 4;
    };
}

@end
