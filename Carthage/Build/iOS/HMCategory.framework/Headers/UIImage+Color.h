//
//  @fileName  UIImage+Color.h
//  @abstract  图片颜色
//  @author    余彪 创建于 2017/5/10.
//  @revise    余彪 最后修改于 2017/5/10.
//  @version   当前版本号 1.0(2017/5/10).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (Color)


/**
 颜色生成图片

 @param color 颜色
 @param size 大小
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 颜色生成图片(默认大小为1)

 @param color 颜色
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 颜色填充图片

 @param tintColor 颜色
 @return UIImage
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

/**
 边框

 @param color 颜色
 @param size 大小
 @param width 宽度
 @return UIImage
 */
- (UIImage *)imageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width;

/**
 圆图

 @param color 颜色
 @param size 大小
 @param width 宽度
 @return UIImage
 */
- (UIImage *)circularImageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width;

@end
