//
//  UIColor+HMGenerate.m
//  Pods
//
//  Created by 余彪 on 2017/5/8.
//
//

#import "UIColor+HMGenerate.h"

@implementation UIColor (HMGenerate)


#pragma mark hex生成Color，alpha为1.0
+ (UIColor *)colorWithHEXString:(NSString *)hexString {
    return [UIColor colorWithHEXString:hexString Alpha:1.0];
}

#pragma mark hex生成Color，可以设置alpha
+ (UIColor *)colorWithHEXString:(NSString *)hexString Alpha:(CGFloat)alpha {
    if (![UIColor judgeHexString:hexString]) {
        return [UIColor clearColor];
    }

    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    } else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if (![UIColor judgeHexString:hexString]) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

#pragma mark RGB模式生成UIColor(alpha为1.0)(自动为您除以255.0)
+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue {
    return [UIColor colorWithRGB:red Green:green Blue:blue Alpha:1.0];
}

#pragma mark RGB模式生成UIColor, alpha可以自己设置(自动为您除以255.0)
+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha {
    CGFloat num = 255.f;
    return [UIColor colorWithRed:red / num green:green / num blue:blue / num alpha:alpha];
}

#pragma mark 颜色组成
+ (UIColor *)composeColor1:(UIColor *)color Color2:(UIColor *)color2 Factor:(CGFloat)value {
    if (!color || !color2) {
        NSLog(@"在颜色组成中, 颜色不能为nil");
        return [UIColor clearColor];
    }
    
    const CGFloat *col1 = CGColorGetComponents(color.CGColor);
    const CGFloat *col2 = CGColorGetComponents(color2.CGColor);
    
    CGFloat r = col1[0] * value + col2[0] * (1 - value);
    CGFloat g = col1[1] * value + col2[1] * (1 - value);
    CGFloat b = col1[2] * value + col2[2] * (1 - value);
    CGFloat a = col1[3] * value + col2[3] * (1 - value);
    UIColor *retColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    return retColor;
}

#pragma mark - Private Method
#pragma mark 校验hex字符串是否合法
+ (BOOL)judgeHexString:(NSString *)hexString {
    if (hexString.length < 6) {
        NSLog(@"hex生成UIColor，需要提供正确的hex值，您提供的为: %@", hexString);
        return NO;
    }
    
    return YES;
}


@end
