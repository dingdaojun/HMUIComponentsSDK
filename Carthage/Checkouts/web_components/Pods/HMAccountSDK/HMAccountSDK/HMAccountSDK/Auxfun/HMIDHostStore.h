//
//  HMIDHostStore.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 账号系统域名缓存管理类
 */
@interface HMIDHostStore : NSObject

/**
 当前使用的账号系统域名

 @return NSString
 */
+ (NSString *)currentUseHost;

/**
 设置当前使用的域名

 @param host NSString
 */
+ (void)setCurrentUseHost:(NSString *)host;

@end
