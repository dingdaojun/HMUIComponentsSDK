//
//  UIView+DesignStyle.m
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIView+DesignStyle.h"

@implementation UIView (DesignStyle)

- (void)hm_setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)hm_setRoundCornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height / 2;
}

- (void)hm_setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)hm_setRoundedCorners:(UIRectCorner)corners
                 cornerRadii:(CGSize)radii {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end
