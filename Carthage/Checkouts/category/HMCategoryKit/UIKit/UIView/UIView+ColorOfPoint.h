//
//  @fileName  UIView+ColorOfPoint.h
//  @abstract  UIView上的点获取颜色值
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIView (ColorOfPoint)


/**
 根据点获取颜色值(Only 小米运动)

 @param point 点
 @return UIColor
 */
- (UIColor *)colorOfPoint:(CGPoint)point;

@end
