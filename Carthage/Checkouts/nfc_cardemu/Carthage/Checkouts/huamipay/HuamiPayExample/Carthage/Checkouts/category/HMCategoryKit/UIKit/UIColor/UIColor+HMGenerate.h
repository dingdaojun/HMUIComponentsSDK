//
//  @fileName  UIColor+HMGenerate.h
//  @abstract  颜色的各种生成方式
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HMGenerate)


/**
 hex生成Color(alpha为1.0)

 @param hexString hex字符串
 @return UIColor
 */
+ (UIColor *)colorWithHEXString:(NSString *)hexString;

/**
 hex生成Color，带alpha设置

 @param hexString hex字符串
 @param alpha alpha(0.0-1.0)
 @return UIColor
 */
+ (UIColor *)colorWithHEXString:(NSString *)hexString Alpha:(CGFloat)alpha;

/**
 RGB模式生成UIColor(alpha为1.0)(自动为您除以255.0)

 @param red Red(0-255.0)
 @param green green(0-255.0)
 @param blue blue(0-255.0)
 @return UIColor
 */
+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

/**
 RGB模式生成UIColor, alpha可以自己设置(自动为您除以255.0)

 @param red Red(0-255.0)
 @param green green(0-255.0)
 @param blue blue(0-255.0)
 @param alpha alpha(0.0-1.0)
 @return UIColor
 */
+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

/**
 颜色组成

 @param color 颜色1
 @param color2 颜色2
 @param value 因子值
 @return UIColor
 */
+ (UIColor *)composeColor1:(UIColor *)color Color2:(UIColor *)color2 Factor:(CGFloat)value;

@end
