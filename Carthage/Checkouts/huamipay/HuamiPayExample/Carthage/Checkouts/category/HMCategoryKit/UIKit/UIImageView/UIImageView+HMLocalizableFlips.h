//
//  UIImageView+CNLocalizableFlips.h
//  CNLocalLanuageDemo
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: yubiao(yubiao@huami.com)
// 

#import <UIKit/UIKit.h>

@interface UIImageView (HMLocalizableFlips)


@property (assign, nonatomic) BOOL isHMFlips;

/**
 强制翻转(注：1、此在国际化下对需要翻转但未翻转图片进行翻转；2、此方法在设置image后调用)
 */
- (void)forceFlipForLocalizable;

@end
