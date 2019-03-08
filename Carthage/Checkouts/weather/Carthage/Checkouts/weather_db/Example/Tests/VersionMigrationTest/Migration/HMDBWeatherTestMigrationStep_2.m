//
//  HMDBWeatherTestMigrationStep_2.m
//  HMDBWeather_Tests
//
//  Created by Karsa Wu on 2018/6/13.
//  Copyright © 2018年 BigNerdCoding. All rights reserved.
//

#import "HMDBWeatherTestMigrationStep_2.h"

@implementation HMDBWeatherTestMigrationStep_2

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    // 实时天气
    [[queryCommand addColumn:@"locationKey" columnInfo:@"TEXT" tableName:@"current_weather" error:error] executeWithError:error];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    
}

@end
