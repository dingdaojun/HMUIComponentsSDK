//
//  UIImage+Color.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 17-5-10.
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import "UIImage+Color.h"
#import "UIImage+HMCorner.h"


@implementation UIImage (Color)


#pragma mark 颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

#pragma mark 颜色填充图片
- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

#pragma mark 边框
- (UIImage *)imageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width {
    UIImage *pureBackground = [UIImage imageWithColor:color size:size];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [pureBackground drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [self drawInRect:CGRectMake(width, width, size.width - width * 2.0, size.height - width * 2.0)];
    UIImage *resultImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark 圆图
- (UIImage *)circularImageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width {
    UIImage *pureBackground = [UIImage imageWithColor:color size:size];
    UIImage *clipped = [pureBackground clipImageToCircle];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [clipped drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [self drawInRect:CGRectMake(width, width, size.width - width * 2.0, size.height - width *2.0)];
    UIImage *resultImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
