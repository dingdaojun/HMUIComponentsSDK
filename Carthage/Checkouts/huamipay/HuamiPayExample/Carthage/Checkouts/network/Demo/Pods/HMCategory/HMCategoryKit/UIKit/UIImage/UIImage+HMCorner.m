//
//  UIImage+HMCorner.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "UIImage+HMCorner.h"


@implementation UIImage (HMCorner)


#pragma mark 圆
- (UIImage *)clipImageToCircle {
    return [self cornerRadius:self.size.width / 2.0];
}

#pragma mark 圆角
- (UIImage *)cornerRadius:(CGFloat)radius {
    return [self cornerRadius:radius borderWidth:0 borderColor:nil];
}

#pragma mark 圆角+边框
- (UIImage *)cornerRadius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat strokeInset = (floor(borderWidth * [UIScreen mainScreen].scale) + 0.5) / [UIScreen mainScreen].scale;
    CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
    CGFloat strokeRadius = radius > [UIScreen mainScreen].scale / 2 ? radius - [UIScreen mainScreen].scale / 2 : 0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
    [path closePath];
    
    path.lineWidth = borderWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    
    if (borderColor) {
        [borderColor setStroke];
        [path stroke];
    }
    
    CGContextSaveGState(context);
    [path addClip];
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextRestoreGState(context);
    
    UIImage *cornerimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cornerimage;
}

#pragma mark 图片合并
+ (UIImage *)multipleImgaeMerge:(UIImage *)imageOne toImage:(UIImage *)imageTwo direction:(HMImageMergeDirection)imageMergeDirection {
    UIImage *togetherImage;
    
    if (imageMergeDirection == HMImageMergeDirectionPortrait) {
        CGSize size = CGSizeMake(imageOne.size.width, imageOne.size.height + imageTwo.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width, imageOne.size.height)];
        [imageTwo drawInRect:CGRectMake(0, imageOne.size.height, imageTwo.size.width, imageTwo.size.height)];
        togetherImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (imageMergeDirection == HMImageMergeDirectionLandscape) {
        CGSize size = CGSizeMake(imageOne.size.width + imageTwo.size.width, imageOne.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width, size.height)];
        [imageTwo drawInRect:CGRectMake(imageOne.size.width, 0, imageTwo.size.width, size.height)];
        togetherImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (imageMergeDirection == HMImageMergeDirectionCover) {
        CGSize size = CGSizeMake(imageOne.size.width, imageOne.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width, imageOne.size.height)];
        [imageTwo drawInRect:CGRectMake((imageOne.size.width - imageTwo.size.width) / 2.0, (imageOne.size.height - imageTwo.size.height) / 2.0, imageTwo.size.width, imageTwo.size.height)];
        togetherImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return togetherImage;
}

@end
