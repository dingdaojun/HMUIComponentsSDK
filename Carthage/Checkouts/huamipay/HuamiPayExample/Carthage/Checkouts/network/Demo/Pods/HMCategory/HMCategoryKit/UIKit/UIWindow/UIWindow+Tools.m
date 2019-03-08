//
//  UIWindow+Tools.m
//  MiFit
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2016年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//


#import "UIWindow+Tools.h"


@implementation UIWindow (Tools)


#pragma mark top Window
+ (UIWindow *)topNormalLevelWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    for (UIWindow *topWindow in windows) {
        if (topWindow.windowLevel == UIWindowLevelNormal)
            return topWindow;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark top ViewController
+ (UIViewController *)topMostViewController {
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        topWindow = [self topNormalLevelWindow];
    }
    
    UIViewController *rootViewController = topWindow.rootViewController;
    
    if(rootViewController == nil) {
        topWindow = [UIApplication sharedApplication].delegate.window;
        
        if (topWindow.windowLevel != UIWindowLevelNormal) {
            topWindow = [self topNormalLevelWindow];
        }
        
        rootViewController = topWindow.rootViewController;
    }
    
    return [self topViewControllerWithRootViewController:rootViewController];
}

#pragma mark 获取最顶层视图控制器
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
