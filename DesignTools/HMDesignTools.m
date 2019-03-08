//
//  HMDesignTools.m
//  MiFit
//
//  Created by dingdaojun on 2017/7/10.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "HMDesignTools.h"
@import HMCategory.UIDevice_Resolutions;

CGFloat const HM4To4_7DesignScale = 320.0f / 375.0f;
CGFloat const HM4_7DesignScale = 1.0f;
CGFloat const HM5_5To4_7DesignScale = 414.0f / 375.0f;

@implementation HMDesignTools

+ (CGFloat)designScaleFontSizeWithOriginalSize:(CGFloat)originalSize {
    CGFloat designScaleFontSize = originalSize;
    
    switch (self.deviceDisplay) {
        case HMDesignToolScreenType4InchBase:
            designScaleFontSize = originalSize * HM4_7DesignScale;
            break;
        case HMDesignToolScreenType5_5InchBase:
            designScaleFontSize = originalSize * HM5_5To4_7DesignScale;
            break;
        case HMDesignToolScreenType4_7InchBase:
        default:
            designScaleFontSize = originalSize * HM4_7DesignScale;
            break;
    }
    return designScaleFontSize;
}

+ (CGFloat)designScaleValueWithOriginalValue:(CGFloat)originalValue {
    CGFloat designScaleValue = originalValue;
    
    switch (self.deviceDisplay) {
        case HMDesignToolScreenType4InchBase:
            designScaleValue = originalValue * HM4To4_7DesignScale;
            break;
        case HMDesignToolScreenType5_5InchBase:
            designScaleValue = originalValue * HM5_5To4_7DesignScale;
            break;
        case HMDesignToolScreenType4_7InchBase:
        default:
            designScaleValue = originalValue * HM4_7DesignScale;
            break;
    }
    return designScaleValue;
}

+ (CGFloat)designPixelSize {
    return 1.0f / [UIScreen mainScreen].scale;
}

+ (CGFloat)disabledStatusAlpha {
    return 0.3;
}

+ (CGFloat)iPhoneTopInset {
    if ([UIDevice isPhoneXDevice]) {
        return 24;
    } else {
        return 0;
    }
}

+ (CGFloat)iPhoneBottomInset {
    if ([UIDevice isPhoneXDevice]) {
        return 34;
    } else {
        return 0;
    }
}

+ (CGFloat)iPhoneNavigationBarHeight {
    if ([UIDevice isPhoneXDevice]) {
        return 88;
    } else {
        return 64;
    }
}

+ (HMDesignToolScreenType)deviceDisplay {
    CGFloat currentScreenWidth = [UIDevice screenWidth];
    
    if (currentScreenWidth == 320) {
        return HMDesignToolScreenType4InchBase;
    } else if (currentScreenWidth == 375) {
        return HMDesignToolScreenType4_7InchBase;
    } else if (currentScreenWidth == 414) {
        return HMDesignToolScreenType5_5InchBase;
    } else {
        NSAssert(YES, @"无此机型");
        return HMDesignToolScreenTypeUnknown;
    }
}

@end

