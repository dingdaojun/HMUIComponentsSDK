//
//  @fileName  UIImage+HMCorner.h
//  @abstract  图片圆角，包含合并图片功能
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 图片合并方向
 
 - HMImageMergeDirectionLandscape: 横向合并
 - HMImageMergeDirectionPortrait: 纵向合并
 - HMImageMergeDirectionCover: 覆盖
 */
typedef NS_ENUM(NSInteger, HMImageMergeDirection) {
    HMImageMergeDirectionLandscape,
    HMImageMergeDirectionPortrait,
    HMImageMergeDirectionCover,
};


@interface UIImage (HMCorner)


/**
 圆

 @return UIImage
 */
- (UIImage *)clipImageToCircle;

/**
 图片添加圆角
 
 @param radius 圆角半径
 
 @return UIImage
 */
- (UIImage *)cornerRadius:(CGFloat)radius;

/**
 图片添加圆角半径和边框
 
 @param radius      圆角半径
 @param borderWidth 边框宽度，<=0 无边框
 @param borderColor 边框颜色
 
 @return UIImage
 */
- (UIImage *)cornerRadius:(CGFloat)radius
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor *)borderColor;

/**
 图片合并
 
 @param imageOne 图片1
 @param imageTwo 图片2
 @param imageMergeDirection 合并方向: 横向合并和纵向合并
 @return 合并后的Image
 */
+ (UIImage *)multipleImgaeMerge:(UIImage *)imageOne toImage:(UIImage *)imageTwo direction:(HMImageMergeDirection)imageMergeDirection;


@end
