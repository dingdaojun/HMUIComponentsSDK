//
//  UIImage+HMData.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "UIImage+HMData.h"


@implementation UIImage (HMData)


#pragma mark 转NSData
- (NSData *)toImageData {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    CGFloat ratio = 0;
    
    if (imageWidth / imageHeight > screenWidth / screenHeight) {
        ratio = screenWidth / imageWidth;
    } else {
        ratio = screenHeight / imageHeight;
    }
    
    imageWidth = ratio * imageWidth;
    imageHeight = ratio * imageHeight;
    
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake((screenWidth - imageWidth) / 2, (screenHeight - imageHeight) / 2, imageWidth, imageHeight)];
    UIImage *image;
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

#pragma mark 压缩NSData
+ (NSData *)compressImageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes {
    if (imageData.length < maxBytes) {
        return imageData;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    CGFloat scale = 2;
    CGFloat newWidth = floorf(image.size.width / scale);
    CGFloat newHeight = floorf(image.size.height / scale);
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newImageData = UIImagePNGRepresentation(scaledImage);
    return newImageData;
}

@end
