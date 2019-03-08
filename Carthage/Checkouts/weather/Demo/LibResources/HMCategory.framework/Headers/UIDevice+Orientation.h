//
//  @fileName  UIDevice+Orientation.h
//  @abstract  方向组
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIApplication+Orientation.h"


@interface UIDevice (Orientation)


/**
 设置允许的屏幕方向组(Only 小米运动)

 @param orientationMask UIInterfaceOrientationMask
 */
+ (void)setInterfaceOrientationMask:(UIInterfaceOrientationMask)orientationMask;

/**
 设置强制的屏幕方向，必须在允许的方向组里(Only 小米运动)

 @param interfaceorientation UIInterfaceOrientation
 @return BOOL
 */
+ (BOOL)setUIInterfaceOrientation:(UIInterfaceOrientation)interfaceorientation;

@end
