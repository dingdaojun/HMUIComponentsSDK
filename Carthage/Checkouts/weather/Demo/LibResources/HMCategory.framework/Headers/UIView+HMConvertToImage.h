//
//  @fileName  UIView+HMConvertToImage.h
//  @abstract  UIView转UIImage
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIView (HMConvertToImage)


/**
 转Image

 @return UIImage
 */
- (UIImage *)toImage;

/**
 转Image

 @param frame frame
 @return UIImage
 */
- (UIImage *)toImageWithFrame:(CGRect)frame;

/**
 父View转Image

 @return UIImage
 */
- (UIImage *)toImageFromSuperView;

/**
 公类(将View转Image)

 @param view view
 @param frame frame
 @return UIImage
 */
+ (UIImage *)toImageFromView:(UIView *)view withFrame:(CGRect)frame;

/**
 将ScrollView转Image

 @return UIImage
 */
- (UIImage *)toImageFromScrollView;

@end
