//  Target_HMDBWeatherDataBase.h
//  Created on 18/12/2017
//  Description CTPersistance 配置信息 类名为 Target_*数据库名*

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>
#import <CTPersistance/CTPersistance.h>

@interface Target_HMDBWeatherDataBase : NSObject<CTPersistanceConfigurationTarget>

- (NSString *)Action_filePath:(NSDictionary *)params;

- (CTPersistanceMigrator *)Action_fetchMigrator:(NSDictionary *)params;

@end
