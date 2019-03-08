//
//  @fileName  UIDevice+Resolutions.h
//  @abstract  分辨率
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 屏幕分辨率类型

 - UIDeviceResolution_Unknown: 未知
 - UIDeviceResolution_iPhoneStandard： // iPhone 1,3,3GS Standard Display   (320x480px)
 - UIDeviceResolution_iPhoneRetina35:  // iPhone 4,4S Retina Display 3.5"  (640x960px)
 - UIDeviceResolution_iPhoneRetina4:   // iPhone 5 Retina Display 4"       (640x1136px)
 - UIDeviceResolution_iPhoneRetina47:  // iPhone 6 Retina Displa 4.7"       (750x1334px)
 - UIDeviceResolution_iPhoneRetina55:  // iPhone 6 Plus Retina Display@3 5.5"   (1242x2208px)    (1080x1920 blend)
 - UIDeviceResolution_iPadStandard:    // iPad 1,2 Standard Display          (1024x768px)
 - UIDeviceResolution_iPadRetina:      // iPad 3 Retina Display              (2048x1536px)
 */
typedef NS_ENUM(NSUInteger, UIDeviceResolution) {
    UIDeviceResolution_Unknown            = 0,
    UIDeviceResolution_iPhoneStandard   = 1,
    UIDeviceResolution_iPhoneRetina35   = 2,
    UIDeviceResolution_iPhoneRetina4    = 3,

    UIDeviceResolution_iPhoneRetina47    = 4,
    UIDeviceResolution_iPhoneRetina55    = 5,

    UIDeviceResolution_iPadStandard     = 6,
    UIDeviceResolution_iPadRetina       = 7,
};


@interface UIDevice (Resolution)


/**
 分辨率

 @return UIDeviceResolution
 */
+ (UIDeviceResolution)resolution;

/**
 机器名称(Only 华米健康) eg iPhone4,1

 @return NSString
 */
+ (NSString *)machineName;

/**
 获取设备用户界面类型(Only 华米健康) eg ios_phone or ios_pad

 @return NSString
 */
+ (NSString *)userInterfaceIdiom;

/**
 屏幕高度

 @return CGFloat
 */
+ (CGFloat)screenHeight;

/**
 屏幕宽度

 @return CGFloat
 */
+ (CGFloat)screenWidth;

/**
 设备屏幕缩放比

 @return CGFloat
 */
+ (CGFloat)screenScale;


/**
 是否是iPhone

 @return BOOL
 */
+ (BOOL)isPhoneDevice;


/**
 是否是iPad

 @return BOOL
 */
+ (BOOL)isPadDevice;

/**
 是否3.5屏设备

 @return BOOL
 */
+ (BOOL)isPhone3_5InchDevice;

/**
 是否4.0屏设备

 @return BOOL
 */
+ (BOOL)isPhone4inchDevice;

/**
 是否是iPhoneX

 @return BOOL
 */
+ (BOOL)isPhoneXDevice;

/**
 是否4.7屏设备

 @return BOOL
 */
+ (BOOL)isPhone4_7InchDevice;

/**
 是否5.5屏设备

 @return BOOL
 */
+ (BOOL)isPhone5_5InchDevice;

/**
 当前设备类型名称

 @return 类型名称   e.g. "iPhone SE"
 */
+ (NSString *)deviceName;

@end
