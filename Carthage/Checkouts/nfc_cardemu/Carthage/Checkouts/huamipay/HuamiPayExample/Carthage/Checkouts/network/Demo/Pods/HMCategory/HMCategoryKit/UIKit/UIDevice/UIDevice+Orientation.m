//
//  UIDevice+Orientation.m
//  MiFit
//
//  Created by fan weirong on 2017/1/9.
//  Copyright © 2017年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//


#import "UIDevice+Orientation.h"


@implementation UIDevice (Orientation)


#pragma mark 设置允许的屏幕方向组
+ (void)setInterfaceOrientationMask:(UIInterfaceOrientationMask)orientationMask {
    UIApplication *application = [UIApplication sharedApplication];
    [application updateOrientationMark:orientationMask];

    [application.delegate application:application supportedInterfaceOrientationsForWindow:application.keyWindow];
}

#pragma mark 设置强制的屏幕方向，必须在允许的方向组里
+ (BOOL)setUIInterfaceOrientation:(UIInterfaceOrientation)interfaceorientation {
    UIApplication *application = [UIApplication sharedApplication];
    if(![UIDevice isOrientation:interfaceorientation inOrientationMask:[application allowScreenOrientationMark]]) {
        NSLog(@"interfaceorientation = %@, orientationMask = %@", @(interfaceorientation),@([application allowScreenOrientationMark]));
        return NO;
    }
    
    //强制归正
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = interfaceorientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    
    return YES;
}


+ (BOOL)isOrientation:(UIInterfaceOrientation)interfaceorientation inOrientationMask:(UIInterfaceOrientationMask)orientationMask {
    switch (orientationMask) {
        case  UIInterfaceOrientationMaskPortrait:
        {
            if(interfaceorientation == UIInterfaceOrientationPortrait) {
                return YES;
            }
        }
            break;
        case UIInterfaceOrientationMaskLandscapeLeft:
        {
            if(interfaceorientation == UIInterfaceOrientationLandscapeLeft) {
                return YES;
            }
        }
            break;
        case UIInterfaceOrientationMaskLandscapeRight:
        {
            if(interfaceorientation == UIInterfaceOrientationLandscapeRight) {
                return YES;
            }
        }
            break;
        case UIInterfaceOrientationMaskPortraitUpsideDown:
        {
            if(interfaceorientation == UIInterfaceOrientationPortraitUpsideDown) {
                return YES;
            }
        }
            break;
        case UIInterfaceOrientationMaskLandscape:
        {
            if(interfaceorientation == UIInterfaceOrientationLandscapeLeft ||
               interfaceorientation == UIInterfaceOrientationLandscapeRight) {
                return YES;
            }
        }
            break;
        case UIInterfaceOrientationMaskAll:
        {
            return YES;
        }
            break;
        case UIInterfaceOrientationMaskAllButUpsideDown:
        {
            if(interfaceorientation != UIDeviceOrientationPortraitUpsideDown) {
                return YES;
            }
        }
            break;
        default:
            break;
    }
    
    return NO;
}

@end
