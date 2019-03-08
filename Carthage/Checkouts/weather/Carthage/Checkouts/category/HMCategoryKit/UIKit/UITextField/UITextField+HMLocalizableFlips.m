//
//  UITextField+CNLocalizableFlips.m
//  MiFit
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: yubiao(yubiao@huami.com)
// 

#import "UITextField+HMLocalizableFlips.h"

@implementation UITextField (HMLocalizableFlips)

#pragma mark 强制文本右对齐(注：1、在从右向左阅读的语言环境下，强制文本内容右对齐)
- (void)forceFlipForLocalizable {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.textAlignment = NSTextAlignmentRight;
    }
}

@end
