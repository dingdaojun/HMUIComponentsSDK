//  HMDBWeatherMigrationStep_2.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherMigrationStep_2.h"

@implementation HMDBWeatherMigrationStep_2

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    // 实时天气
    [[queryCommand addColumn:@"locationKey" columnInfo:@"TEXT" tableName:@"current_weather" error:error] executeWithError:error];

    // AQI
    [[queryCommand addColumn:@"locationKey" columnInfo:@"TEXT" tableName:@"weather_aqi" error:error] executeWithError:error];

    // 预警
    [[queryCommand addColumn:@"locationKey" columnInfo:@"TEXT" tableName:@"weather_earlyWarning" error:error] executeWithError:error];

    // 预报
    [[queryCommand addColumn:@"locationKey" columnInfo:@"TEXT" tableName:@"weather_forcast"  error:error] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {

}

@end
