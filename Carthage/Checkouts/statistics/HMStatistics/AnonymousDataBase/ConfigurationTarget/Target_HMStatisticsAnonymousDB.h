//  Target_HMStatisticsAnonymousDB.h
//  Created on 2018/4/12
//  Description CTPersistance 使用的配置信息文件。因使用了 RunTime 机制类名必须为：Target_数据库名

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistance.h>

@interface Target_HMStatisticsAnonymousDB : NSObject<CTPersistanceConfigurationTarget>

/**
 数据库路径配置接口

 @param params 参数，详见 CTPersistanceConfigurationTarget
 @return 数据库路径
 */
- (NSString *)Action_filePath:(NSDictionary *)params;

/**
 匿名统计数据库迁移

 @param params <#params description#>
 @return <#return value description#>
 */
- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;
@end