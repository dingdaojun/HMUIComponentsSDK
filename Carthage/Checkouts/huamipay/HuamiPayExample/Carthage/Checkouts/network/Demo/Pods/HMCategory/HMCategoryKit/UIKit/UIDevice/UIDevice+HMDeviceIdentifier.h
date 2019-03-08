//
//  @fileName  UIDevice+HMDeviceIdentifier.h
//  @abstract  设备ID
//  @author    余彪 创建于 2017/5/15.
//  @revise    余彪 最后修改于 2017/5/15.
//  @version   当前版本号 1.0(2017/5/15).
//  Copyright © 2017年 HM iOS. All rights reserved.
//



#import <UIKit/UIKit.h>


@interface UIDevice (HMDeviceIdentifier)


/**
 设备ID(Only 小米运动)

 @return NSString
 */
+ (NSString *)uniqueDeviceIdentifier;

@end
