//
//  UITextField+CNLocalizableFlips.h
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: yubiao(yubiao@huami.com)
// 

#import <UIKit/UIKit.h>


@interface UITextField (HMLocalizableFlips)

/**
 强制文本右对齐(注：1、在从右向左阅读的语言环境下，强制文本内容右对齐)
 */
- (void)forceFlipForLocalizable;

@end
