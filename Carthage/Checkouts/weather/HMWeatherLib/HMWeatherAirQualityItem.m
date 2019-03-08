//  HMWeatherAirQualityItem.m
//  Created on 2018/1/4
//  Description 空气质量

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherAirQualityItem.h"
@import HMCategory.NSDate_HMStringFormat;

@implementation HMWeatherAirQualityItem

- (instancetype)initWithAQIData:(id<HMServiceAPIWeatherAirQualityData>)airQualityData locationKey:(NSString *)locationKey {
    self = [super init];
    if (self) {
        self.aqi = airQualityData.api_airQualityDataAQI;
        self.co = airQualityData.api_airQualityDataCO;
        self.no2 = airQualityData.api_airQualityDataNO2;
        self.o3 = airQualityData.api_airQualityDataO3;
        self.pm10 = airQualityData.api_airQualityDataPM10;
        self.pm25 = airQualityData.api_airQualityDataPM25;
        self.primary = airQualityData.api_airQualityDataPrimary;
        self.src = airQualityData.api_airQualityDataSource;
        self.so2 = airQualityData.api_airQualityDataSO2;
        self.pubTime = [airQualityData.api_airQualityDataPubTime stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
        self.lastUpdateDate = [NSDate date];
        self.locationKey = locationKey;
    }
    return self;
}

- (instancetype)initWithDBAqiData:(id<HMDBWeatherAQIProtocol>)dbAqiData {
    self = [super init];
    if (self) {
        self.aqi = dbAqiData.dbValueOfAQI;
        self.pubTime = dbAqiData.dbWeatherAQIPublishTime;
        self.lastUpdateDate = dbAqiData.dbRecordUpdateTime;
        self.locationKey = dbAqiData.dbLocationKey;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pubTime:%@ Aqi:%ld",self.pubTime, (long)self.aqi];
}

#pragma mark - db fields
// 空气质量发布时间
- (NSString *)dbWeatherAQIPublishTime {
    return self.pubTime;
}
// 空气质量数值
- (NSInteger)dbValueOfAQI {
    return self.aqi;
}
// 数据库记录更新时间
- (NSDate *)dbRecordUpdateTime {
    return self.lastUpdateDate;
}
// 行政区key
- (NSString *)dbLocationKey {
    return self.locationKey;
}

#pragma mark - 返回的数据结构
/*{
    no2 = 24;
    co = 0.50;
    brandInfo = {
        brands = (
                  {
                      brandId = CNEMC;
                      names = {
                          en_US = CNEMC;
                          zh_TW = 中國環境監測總站;
                          zh_CN = 中国环境监测总站;
                      }
                      ;
                      url = ;
                      logo = ;
                  }
                  ,
                  );
    };
    src = 中国环境监测总站;
    aqi = 29;
    so2 = 8;
    pubTime = 2018-01-05T14:00:00+08:00;
    pm25 = 18;
    o3 = 56;
    primary = ;
    pm10 = 28;
    status = 0;
}*/
@end
