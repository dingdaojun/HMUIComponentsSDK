//
//  UIView+ColorOfPoint.m
//
//  Created by Ivan Zezyulya on 12.01.11.
//

#import "UIView+ColorOfPoint.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (ColorOfPoint)


#pragma mark 根据点获取颜色值
- (UIColor *)colorOfPoint:(CGPoint)point {
	unsigned char pixel[4] = {0};

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);

	CGContextTranslateCTM(context, -point.x, -point.y);

	[self.layer renderInContext:context];

	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	UIColor *color = [UIColor colorWithRed:pixel[0] / 255.0 green:pixel[1] / 255.0 blue:pixel[2] / 255.0 alpha:pixel[3] / 255.0];

	return color;
}

@end
