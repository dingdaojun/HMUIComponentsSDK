//
//  NSDictionary+HMPickerAttributes.h
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/10/30.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HMPickerAttributes)

//用于各类引导页的picker
+ (NSDictionary *)attributesForSettingGuidePickerView;
+ (NSDictionary *)attributesForSettingGuidePickerViewSelected;

//用于各类白色背景，蓝色字的picker
+ (NSDictionary *)attributesForWhiteBackgroundPickerView;
+ (NSDictionary *)attributesForWhiteBackgroundPickerViewSelected;

//用于各类ActionSheet的picker
+ (NSDictionary *)attributesForActionSheetPickerView;
+ (NSDictionary *)attributesForActionSheetPickerViewSelected;

@end
