//
//  UIView+DesignStyle.h
//  MiFit
//
//  Created by dingdaojun on 15/11/27.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DesignStyle)

- (void)hm_setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (void)hm_setRoundCornerRadius;

- (void)hm_setCornerRadius:(CGFloat)cornerRadius;

- (void)hm_setRoundedCorners:(UIRectCorner)corners
                 cornerRadii:(CGSize)radii;
    
@end
