//
//  NSString+AZQuantityStringBuilder.h
//  MiFit
//
//  Created by dingdaojun on 15/12/25.
//  Copyright © 2015年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AZQuantityStringBuilder)

/**
 根据秒数显示四舍五入的“几分钟”

 @param seconds 秒数
 @param needToAppendUnit 是否需要附带单位
 @return “几分钟”字符串对象
 */
+ (NSString *)hm_roundedMinutesStringWithSeconds:(NSTimeInterval)seconds needToAppendUnit:(BOOL)needToAppendUnit;

@end
