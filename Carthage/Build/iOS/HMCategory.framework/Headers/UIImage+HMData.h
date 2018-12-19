//
//  @fileName  UIImage+HMData.h
//  @abstract  图片转NSData
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIImage (HMData)


/**
 转NSData

 @return NSData
 */
- (NSData *)toImageData;

/**
 压缩NSData

 @param imageData NSData
 @param maxBytes maxBytes
 @return NSData
 */
+ (NSData *)compressImageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes;

@end
