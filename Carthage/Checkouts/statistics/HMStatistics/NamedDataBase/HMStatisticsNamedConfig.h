//  HMStatisticsNamedConfig.h
//  Created on 2018/4/12
//  Description 具名统计数据库配置

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@interface HMStatisticsNamedConfig : NSObject

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
