//
//  UIImage+HMGradient.h
//  MiDongTrainingCenter
//
//  Created by dingdaojun on 2017/11/7.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, HMGradientStyle) {
    HMGradientStyleLeftToRight,
    HMGradientStyleRadial,
    HMGradientStyleTopToBottom
};
@interface UIImage (HMGradient)

+ (instancetype)hmImageWithGradientStyle:(HMGradientStyle)gradientStyle withFrame:(CGRect)frame andColors:(NSArray *)colors;
    
@end
