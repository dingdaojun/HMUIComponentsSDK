//
//  UIImage+HMScale.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import "UIImage+HMScale.h"


@implementation UIImage (HMScale)


#pragma mark 等比率缩放
- (UIImage *)scaleImageToScale:(float)scaleSize {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize), NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
