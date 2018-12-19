//
//  NSDictionary+HMAttributes.m
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+HMAttributes.h"
#import "UIColor+HMCommonColors.h"

@implementation NSDictionary (HMAttributes)

#pragma mark - 通用工厂方法 -

+ (NSDictionary *)hmDictionaryWithNumberColor:(UIColor *)numberColor numberFont:(UIFont *)numberFont {
    NSDictionary *numberAttributesDictionary = @{ NSFontAttributeName : numberFont,
                                                  NSForegroundColorAttributeName : numberColor };
    return numberAttributesDictionary;
}

+ (NSDictionary *)hmDictionaryWithTextColor:(UIColor *)textColor textFont:(UIFont *)textFont {
    NSDictionary *textAttributesDictionary = @{ NSFontAttributeName : textFont,
                                                NSForegroundColorAttributeName : textColor };
    return textAttributesDictionary;
}

+ (NSDictionary *)hmDictionaryWithNumberColor:(UIColor *)numberColor textColor:(UIColor *)textColor numberFont:(UIFont *)numberFont textFont:(UIFont *)textFont {
    NSDictionary *numberAttributesDictionary = @{ NSFontAttributeName : numberFont,
                                                  NSForegroundColorAttributeName : numberColor };
    NSDictionary *textAttributesDictionary = @{ NSFontAttributeName : textFont,
                                                NSForegroundColorAttributeName : textColor };
    return @{ HMNumberAttributesKey : numberAttributesDictionary,
              HMTextAttributesKey : textAttributesDictionary };
}

+ (NSDictionary *)hmDictionaryWithNeedToBeCenteredAttributesDictionary:(NSDictionary *)attributesDictionary {
    NSMutableDictionary *mutableAttributesDictionary = [attributesDictionary mutableCopy];
    NSMutableDictionary *textAttributesDictionary = [attributesDictionary[HMTextAttributesKey] mutableCopy];
    textAttributesDictionary[NSForegroundColorAttributeName] = [UIColor clearColor];
    mutableAttributesDictionary[HMTextClearedAttributesKey] = textAttributesDictionary;
    mutableAttributesDictionary[HMNeedToBeCenteredAttributesKey] = @(YES);
    return [mutableAttributesDictionary copy];
}

#pragma mark - 以下用于具体的页面类型的公有方法必须加注释，命名规则：通用的，在末尾加s -

// 用于多行文本
+ (NSParagraphStyle *)multiLineParagraphStyleWithAlignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return paragraphStyle;
}

// 用于alert view
+ (NSDictionary *)multiLineAlertStyleAttributes {
    NSParagraphStyle *paragraphStyle = [self multiLineParagraphStyleWithAlignment:NSTextAlignmentLeft];
    return @{ NSParagraphStyleAttributeName : paragraphStyle,
              NSForegroundColorAttributeName : [UIColor blackColorWithAlpha:0.4],
              NSFontAttributeName : [UIFont systemFontOfSize:14] };
}

// 用于调整间距
+ (NSDictionary *)spaceAttribute
{
    return @{ NSFontAttributeName : [UIFont systemFontOfSize:8] };
}

@end
