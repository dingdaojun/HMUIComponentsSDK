//
//  UIImageView+CNLocalizableFlips.m
//  CNLocalLanuageDemo
//
//  Copyright(c)2017 Huami Inc. All Rights Reserved.
//  Author: yubiao(yubiao@huami.com)
// 

#import "UIImageView+HMLocalizableFlips.h"
#import <objc/runtime.h>

static char const * const kImageViewIsFlips = "kImageViewIsFlips";

@implementation UIImageView (HMLocalizableFlips)

#pragma mark 强制翻转(注：1、此在国际化下对需要翻转但未翻转图片进行翻转；2、此方法在设置image后调用)
- (void)forceFlipForLocalizable {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        if (@available(iOS 9.0, *)) {
                // 9以上系统，采用此方案
            if (self.image && !self.image.flipsForRightToLeftLayoutDirection) {
                UIImage *image = self.image;
                self.image = [image imageFlippedForRightToLeftLayoutDirection];
            }
        } else {
            if (self.image && !self.isHMFlips) {
                UIImage *image = self.image;
                UIImage *flipImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUpMirrored];
                self.image = flipImage;
            }
        }
    }
}

#pragma mark Setter/Getter
- (void)setIsHMFlips:(BOOL)isHMFlips {
    if (self.isHMFlips) {
        return;
    }
    
    objc_setAssociatedObject(self, kImageViewIsFlips, @(isHMFlips), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isHMFlips {
    return [objc_getAssociatedObject(self, kImageViewIsFlips) boolValue];
}

@end
