//
//  UIButton+HMLocalizableFlips.m
//  MiFit
//
//  Created by 余彪 on 16/12/8.
//  Copyright © 2016年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import "UIButton+HMLocalizableFlips.h"
#import <objc/runtime.h>


static char const * const kButtonIsFlips = "kButtonIsFlips";


@implementation UIButton (HMLocalizableFlips)


#pragma mark 强制翻转(注：1、此在国际化下对需要翻转但未翻转图片进行翻转；2、此方法在设置image后调用)
- (void)forceFlipForLocalizable {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        // 这里这么写比较蛋疼，大家有木有什么好的建议，把枚举转数组
        NSArray *statueArray = @[@(UIControlStateNormal), @(UIControlStateHighlighted),
                           @(UIControlStateDisabled),@(UIControlStateSelected),
                           @(UIControlStateApplication),
                           @(UIControlStateReserved)];
        
        if (@available(iOS 9.0, *)) {
            // ios版本大于9
            NSMutableArray *statusMulArray = [NSMutableArray arrayWithArray:statueArray];
            [statusMulArray addObject:@(UIControlStateFocused)];
            statueArray = [NSArray arrayWithArray:statusMulArray];
        }
        
        [statueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIControlState state = [obj integerValue];
            UIImage *currentImage = [self imageForState:state];
            UIImage *backgroudImage = [self backgroundImageForState:state];
        
            if (@available(iOS 9.0, *)) {
                if (currentImage && !currentImage.flipsForRightToLeftLayoutDirection) {
                    [self setImage:[currentImage imageFlippedForRightToLeftLayoutDirection] forState:state];
                }
                
                if (backgroudImage && !backgroudImage.flipsForRightToLeftLayoutDirection) {
                    [self setBackgroundImage:[backgroudImage imageFlippedForRightToLeftLayoutDirection] forState:state];
                }
            } else {
                if (currentImage && !self.isHMFlips) {
                    UIImage *flipImage = [UIImage imageWithCGImage:currentImage.CGImage scale:currentImage.scale orientation:UIImageOrientationUpMirrored];
                    [self setImage:flipImage forState:state];
                }
                
                if (backgroudImage && !self.isHMFlips) {
                    UIImage *flipImage = [UIImage imageWithCGImage:backgroudImage.CGImage scale:backgroudImage.scale orientation:UIImageOrientationUpMirrored];
                    [self setBackgroundImage:flipImage forState:state];
                }
            }
        }];
    }
}

#pragma mark 文本对其
- (void)textAlignmentForLocalizable {
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}

#pragma mark Setter/Getter
- (void)setIsHMFlips:(BOOL)isHMFlips{
    if (self.isHMFlips) {
        return;
    }
    
    objc_setAssociatedObject(self, kButtonIsFlips, @(isHMFlips), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isHMFlips {
    return [objc_getAssociatedObject(self, kButtonIsFlips) boolValue];
}

@end
