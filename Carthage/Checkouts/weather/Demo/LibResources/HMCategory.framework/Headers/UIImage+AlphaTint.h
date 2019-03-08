//
//  @fileName  UIImage+AlphaTint.h
//  @abstract  UIImage 根据颜色改变图片颜色, 生成新的图片
//  @author    江杨 创建于 2017/5/22.
//  @revise    江杨 最后修改于 2017/5/22.
//  @version   当前版本号 1.0(2017/5/22).
//  Copyright © 2017年 HM iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AlphaTint)

/**
 change image color, keep gradient alpha info

 @return image with gradient alpha info
 */
- (UIImage *)imageWithAlphaTint:(UIColor *)tintColor;

@end
