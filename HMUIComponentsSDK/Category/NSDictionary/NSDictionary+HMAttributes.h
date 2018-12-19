//
//  NSDictionary+HMAttributes.h
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const HMNumberAttributesKey = @"HMNumberAttributesKey";

static NSString *const HMTextAttributesKey = @"HMTextAttributesKey";

static NSString *const HMNeedToBeCenteredAttributesKey = @"HMNeedToBeCenteredAttributesKey";

static NSString *const HMTextClearedAttributesKey = @"HMTextClearedAttributesKey";

@interface NSDictionary (HMAttributes)

+ (NSDictionary *)hmDictionaryWithNumberColor:(UIColor *)numberColor numberFont:(UIFont *)numberFont;
    
+ (NSDictionary *)hmDictionaryWithNumberColor:(UIColor *)numberColor textColor:(UIColor *)textColor numberFont:(UIFont *)numberFont textFont:(UIFont *)textFont;

// 用于多行文本
+ (NSParagraphStyle *)multiLineParagraphStyleWithAlignment:(NSTextAlignment)alignment;

//用于alert view
+ (NSDictionary *)multiLineAlertStyleAttributes;
    
// 用于调整间距
+ (NSDictionary *)spaceAttribute;

@end
