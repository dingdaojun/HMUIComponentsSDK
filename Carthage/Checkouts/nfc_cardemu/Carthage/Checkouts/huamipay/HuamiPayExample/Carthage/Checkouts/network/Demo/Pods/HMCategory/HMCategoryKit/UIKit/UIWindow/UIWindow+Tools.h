//
//  @fileName  UIWindow+Tools.h
//  @abstract  Top Winow Top ViewController
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIWindow (Tools)


/**
 顶部window(Only 小米运动)

 @return UIWindow
 */
+ (UIWindow *)topNormalLevelWindow;

/**
 UIViewController(Only 小米运动)

 @return UIViewController
 */
+ (UIViewController *)topMostViewController;

@end
