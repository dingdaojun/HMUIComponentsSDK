//
//  UIColor+HMCommonColors.m
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/7/10.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIColor+HMCommonColors.h"

@implementation UIColor (HMCommonColors)

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alpha {
    return rgba(255, 255, 255, alpha);
}

+ (UIColor *)blackColorWithAlpha:(CGFloat)alpha {
    return rgba(0, 0, 0, alpha);
}

+ (UIColor *)trainingBlackColor40Percent {
    return rgba(0, 0, 0, 0.40);
}

+ (UIColor *)trainingBlackColor20Percent {
    return rgba(0, 0, 0, 0.20);
}
@end
