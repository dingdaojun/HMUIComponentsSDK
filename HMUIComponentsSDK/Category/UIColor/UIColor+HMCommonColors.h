//
//  UIColor+HMCommonColors.h
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/7/10.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define hsba(h,s,b,a) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:a]
#define hsb(h,s,b) [UIColor colorWithHue:h/360.0f saturation:s/100.0f brightness:b/100.0f alpha:1.0]

@interface UIColor (HMCommonColors)

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)blackColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)trainingBlackColor40Percent;

+ (UIColor *)trainingBlackColor20Percent;
@end
