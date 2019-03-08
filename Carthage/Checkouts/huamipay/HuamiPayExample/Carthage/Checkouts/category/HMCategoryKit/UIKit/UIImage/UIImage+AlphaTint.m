//
//  UIImage+AlphaTint.m
//  Pods
//
//  Created by 江杨 on 22/05/2017.
//
//


#import "UIImage+AlphaTint.h"


@implementation UIImage (AlphaTint)


#pragma mark alphaTint Color
- (UIImage *)imageWithAlphaTint:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end
