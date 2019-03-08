//
//  @fileName  UIApplication+Orientation.h
//  @abstract  方向
//  @author    余彪 创建于 2017/5/8.
//  @revise    余彪 最后修改于 2017/5/8.
//  @version   当前版本号 1.0(2017/5/8).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIApplication (Orientation)


/**
 更新方向(Only 小米运动)

 @param orientationMark UIInterfaceOrientationMask
 */
- (void)updateOrientationMark:(UIInterfaceOrientationMask)orientationMark;

/**
 获取方向(Only 小米运动)

 @return UIInterfaceOrientationMask
 */
- (UIInterfaceOrientationMask)allowScreenOrientationMark;

@end
