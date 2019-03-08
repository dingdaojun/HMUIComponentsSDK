//  HMStatisticsAnonymousConfig.h
//  Created on 2018/4/12
//  Description 匿名数据库配置信息

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@interface HMStatisticsAnonymousConfig : NSObject

/**
 获取数据库名称

 @return 数据库名称
 */
+ (NSString *)dataBaseName;

/**
 清空数据库

 @return 是否操作成功
 */
+ (BOOL)clearDatabase;

@end
