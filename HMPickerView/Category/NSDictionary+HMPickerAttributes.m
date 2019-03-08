//
//  NSDictionary+HMPickerAttributes.m
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/10/30.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+HMPickerAttributes.h"
#import "UIColor+HMPickerDesignColors.h"
#import "UIColor+HMCommonColors.h"
#import "NSDictionary+HMAttributes.h"

@implementation NSDictionary (HMPickerAttributes)

//用于各类引导页的picker
+ (NSDictionary *)attributesForSettingGuidePickerView {
    return [self hmDictionaryWithNumberColor:[UIColor whiteColorWithAlpha:0.3] numberFont:[UIFont systemFontOfSize:48]];
}

+ (NSDictionary *)attributesForSettingGuidePickerViewSelected {
    return [self hmDictionaryWithNumberColor:[UIColor whiteColorWithAlpha:1.0] numberFont:[UIFont systemFontOfSize:48]];
}

//用于各类白色背景，蓝色字的picker
+ (NSDictionary *)attributesForWhiteBackgroundPickerView {
    return [self hmDictionaryWithNumberColor:[UIColor blackColorWithAlpha:0.2] numberFont:[UIFont systemFontOfSize:30]];
}

+ (NSDictionary *)attributesForWhiteBackgroundPickerViewSelected {
    return [self hmDictionaryWithNumberColor:[UIColor hmWhiteBackgroundPickerSelectedColor] numberFont:[UIFont systemFontOfSize:30]];
}

//用于各类ActionSheet的picker
+ (NSDictionary *)attributesForActionSheetPickerView {
    return [self hmDictionaryWithNumberColor:[UIColor blackColorWithAlpha:0.6] numberFont:[UIFont systemFontOfSize:19]];
}

+ (NSDictionary *)attributesForActionSheetPickerViewSelected {
    return [self hmDictionaryWithNumberColor:[UIColor hmPickerSelectedColor] numberFont:[UIFont systemFontOfSize:19]];
}

@end
