//  HMWeatherCurrentItem.m
//  Created on 2018/1/4
//  Description 当前天气信息

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherCurrentItem.h"
@import HMCategory.NSDate_HMStringFormat;

@implementation HMWeatherCurrentItem

- (instancetype)initWithRealTimeData:(id<HMServiceAPIWeatherRealTimeData>)realTimeData locationKey:(NSString *)locationKey{
    self = [super init];
    if (self) {
        self.pubTime = [realTimeData.api_realTimeDataPubTime stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
        self.lastUpdateDate = [NSDate date];
        self.locationKey = locationKey;
        self.uvIndex = realTimeData.api_realTimeDataUVIndex;
        self.weather = realTimeData.api_realTimeDataWeather;
        
        self.curFeelsLikeUnit = realTimeData.api_realTimeDataFeelsLike.api_realTimeDataUnit;
        self.curFeelsLikeValue = realTimeData.api_realTimeDataFeelsLike.api_realTimeDataValue;
        
        self.visibilityUnit = realTimeData.api_realTimeDataVisibility.api_realTimeDataUnit;
        self.visibilityValue = realTimeData.api_realTimeDataVisibility.api_realTimeDataValue;
        
        self.curHumidityUnit = realTimeData.api_realTimeDataHumidity.api_realTimeDataUnit;
        self.curFeelsLikeValue = realTimeData.api_realTimeDataHumidity.api_realTimeDataValue;
        
        self.curPressureUnit = realTimeData.api_realTimeDataPressure.api_realTimeDataUnit;
        self.curPressureValue = realTimeData.api_realTimeDataPressure.api_realTimeDataValue;
        
        self.curTemperatureUnit = realTimeData.api_realTimeDataTemperature.api_realTimeDataUnit;
        self.curTemperatureValue = realTimeData.api_realTimeDataTemperature.api_realTimeDataValue;
        if ([self.curTemperatureUnit isEqualToString:@"℉"]) {
            self.curTemperatureUnit = @"℃";
            NSInteger curTemperatureV = ([self.curTemperatureValue integerValue] - 32) / 1.8;
            self.curTemperatureValue = [NSString stringWithFormat:@"%ld",curTemperatureV];
        }
        
        self.windSpeedUnit = realTimeData.api_realTimeDataWindSpeed.api_realTimeDataUnit;
        self.windSpeedValue = realTimeData.api_realTimeDataWindSpeed.api_realTimeDataValue;
        
        self.windDirectionUnit = realTimeData.api_realTimeDataWindDirection.api_realTimeDataUnit;
        self.windDirectionValue = realTimeData.api_realTimeDataWindDirection.api_realTimeDataValue;
    }
    return self;
}

- (instancetype)initWithDBRealTimeData:(id<HMDBCurrentWeatherProtocol>)dbRealTimeData {
    self = [super init];
    if (self) {
        self.pubTime = dbRealTimeData.dbWeatherPublishTime;
        self.weather = dbRealTimeData.dbWeatherType;
        self.curTemperatureValue = [NSString stringWithFormat:@"%ld",(long)dbRealTimeData.dbTemperature];
        self.curTemperatureUnit = dbRealTimeData.dbTemperatureUnit;
        self.lastUpdateDate = dbRealTimeData.dbRecordUpdateTime;
        self.locationKey = dbRealTimeData.dbLocationKey;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pubTime:%@ \n weather:%ld \n tempUnit:%@ \n tempValue:%@",self.pubTime,(long)self.weather,self.curTemperatureUnit,self.curTemperatureValue];
}

#pragma mark - db fields
// 天气数据发布时间
- (NSString *)dbWeatherPublishTime {
    return self.pubTime;
}
// 天气类型
- (NSInteger)dbWeatherType {
    return self.weather;
}
// 温度
- (NSInteger)dbTemperature {
    return [self.curTemperatureValue integerValue];
}
// 温度单位
- (NSString *)dbTemperatureUnit {
    return self.curTemperatureUnit;
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
    visibility = {
        value = ;
        unit = km;
    }
    ;
    humidity = {
        value = 16;
        unit = %;
    }
    ;
    wind = {
        speed = {
            value = 3.0;
            unit = km/h;
        }
        ;
        direction = {
            value = 0;
            unit = °;
        }
        ;
    }
    ;
    feelsLike = {
        value = 1;
        unit = ℃;
    }
    ;
    pressure = {
        value = 1026.5;
        unit = mb;
    }
    ;
    temperature = {
        value = 2;
        unit = ℃;
    }
    ;
    pubTime = 2018-01-05T14:40:00+08:00;
    weather = 0;
    uvIndex = 2;
}*/
@end

