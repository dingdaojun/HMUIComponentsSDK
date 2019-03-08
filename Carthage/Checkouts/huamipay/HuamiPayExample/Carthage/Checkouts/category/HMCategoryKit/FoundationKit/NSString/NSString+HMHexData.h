//
//  @fileName  NSString+HMHexData.h
//  @abstract  16进制相关操作: 转NSData、格式化mac地址、规整mac地址及固件版本比较
//  @author    余彪 创建于 2017/5/9.
//  @revise    余彪 最后修改于 2017/5/9.
//  @version   当前版本号 1.0(2017/5/9).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSString (HMHexData)


/**
 转成NSData(only: 小米运动)

 @return NSData
 */
- (NSData *)toDataForHexString;

/**
 格式化mac地址，ex: 00:00:00:00:00:00(only: 小米运动)

 @return NSString
 */
- (NSString *)formatPeripheralMacAddress;

/**
 mac地址串，不包含任何其他符号, ex: 000000000000(only: 小米运动)

 @return NSString
 */
- (NSString *)peripheralMacAddress;

/**
 比较固件版本(only: 小米运动)

 @param versionString 版本
 @return YES/NO
 */
- (BOOL)isEqualToFirmwareVersion:(NSString *)versionString;

@end
