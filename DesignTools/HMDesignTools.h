//
//  HMDesignTools.h
//  MiFit
//
//  Created by dingdaojun on 2017/7/10.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern CGFloat const HM4To4_7DesignScale;
extern CGFloat const HM4_7DesignScale;
extern CGFloat const HM5_5To4_7DesignScale;

typedef NS_ENUM(NSUInteger, HMDesignToolScreenType) {
    HMDesignToolScreenTypeUnknown,
    HMDesignToolScreenType4InchBase,
    HMDesignToolScreenType4_7InchBase,
    HMDesignToolScreenType5_5InchBase,
};

@interface HMDesignTools : NSObject

+ (CGFloat)designScaleFontSizeWithOriginalSize:(CGFloat)originalSize;
+ (CGFloat)designScaleValueWithOriginalValue:(CGFloat)originalValue;

@property (assign, class, nonatomic, readonly) CGFloat designPixelSize;
@property (assign, class, nonatomic, readonly) CGFloat disabledStatusAlpha;
@property (assign, class, nonatomic, readonly) CGFloat iPhoneTopInset;
@property (assign, class, nonatomic, readonly) CGFloat iPhoneBottomInset;
@property (assign, class, nonatomic, readonly) CGFloat iPhoneNavigationBarHeight;

@end
