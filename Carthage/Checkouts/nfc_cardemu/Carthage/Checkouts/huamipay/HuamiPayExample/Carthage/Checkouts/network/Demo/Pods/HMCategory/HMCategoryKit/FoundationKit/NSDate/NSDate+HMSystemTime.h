//
//  @fileName  NSDate+HMSystemTime.h
//  @abstract  NSDate 12、24小时制处理
//  @author    余彪 创建于 2017/5/16.
//  @revise    余彪 最后修改于 2017/5/16.
//  @version   当前版本号 1.0(2017/5/16).
//  Copyright © 2017年 HM iOS. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSDate (HMSystemTime)


/**
 是否是24小时制
 
 @return YES ？ 是 ：不是
 */
+ (BOOL)is24hourTimeSystem;

@end
