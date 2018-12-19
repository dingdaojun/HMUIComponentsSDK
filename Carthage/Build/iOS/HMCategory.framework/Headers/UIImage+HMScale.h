//
//  @fileName  UIImage+HMScale.h
//  @abstract  图片缩放操作
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (HMScale)


/**
 图片缩放
 
 @param scaleSize 缩放比例
 @return UIImage
 */
- (UIImage *)scaleImageToScale:(float)scaleSize;

@end
