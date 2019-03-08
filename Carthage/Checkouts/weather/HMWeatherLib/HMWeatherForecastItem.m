//  HMWeatherForecastItem.m
//  Created on 2018/1/4
//  Description 天气预告

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherForecastItem.h"
@import HMCategory.NSDate_HMStringFormat;
@import HMCategory.NSDate_HMAdjust;

@implementation HMWeatherForecastItem

+ (NSArray<HMWeatherForecastItem *> *)forecastItemsWithData:(id<HMServiceAPIWeatherForecastData>)datas locationKey:(NSString *)locationKey {
    NSMutableArray *forecasts = [NSMutableArray array];
    NSInteger weatherCount = datas.api_forecastDataWeather.api_forecastDataValues.count;
    NSArray<id<HMServiceAPIWeatherForecastSunRiseSetProtocol>> *sunRiseSets = datas.api_forecastDataSunRiseSet;
    NSArray<id<HMServiceAPIWeatherForecastDataValueProtocol>> *weatherValues = datas.api_forecastDataWeather.api_forecastDataValues;
    NSArray<id<HMServiceAPIWeatherForecastDataValueProtocol>> *windDirectValues = datas.api_forecastDataWindDirection.api_forecastDataValues;
    NSArray<id<HMServiceAPIWeatherForecastDataValueProtocol>> *speedValues = datas.api_forecastDataWindSpeed.api_forecastDataValues;
    
    for (NSInteger i = 0; i < weatherCount; i++) {
        HMWeatherForecastItem *item = [[HMWeatherForecastItem alloc] init];
        item.aqiValues = datas.api_forecastDataAqi;
        
        if (i < sunRiseSets.count) {
            item.sunRiseFromValue = [[sunRiseSets objectAtIndex:i].api_forecastSunriseDate stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
            item.sunRiseToValue = [[sunRiseSets objectAtIndex:i].api_forecastSunsetDate stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
        } else {
            item.sunRiseFromValue = nil;
            item.sunRiseToValue = nil;
        }
        
        item.temperatureUnit = datas.api_forecastDataTemperature.api_forecastDataUnit;
        item.temperatureFromValue = [datas.api_forecastDataTemperature.api_forecastDataValues objectAtIndex:i].api_forecastDataFromValue;
        item.temperatureToValue = [datas.api_forecastDataTemperature.api_forecastDataValues objectAtIndex:i].api_forecastDataToValue;
        if ([item.temperatureUnit isEqualToString:@"℉"]) {
            item.temperatureUnit = @"℃";
            NSInteger temperatureF = ([item.temperatureFromValue integerValue] - 32) / 1.8;
            NSInteger temperatureT = ([item.temperatureToValue integerValue] - 32) / 1.8;
            item.temperatureFromValue = [NSString stringWithFormat:@"%ld",(long)temperatureF];
            item.temperatureToValue = [NSString stringWithFormat:@"%ld",(long)temperatureT];
        }
        
        if (i < weatherValues.count) {
            item.weatherFromValue = [weatherValues objectAtIndex:i].api_forecastDataFromValue;
            item.weatherToValue = [weatherValues objectAtIndex:i].api_forecastDataToValue;
        } else {
            item.weatherFromValue = nil;
            item.weatherToValue = nil;
        }
        
        item.windDirectionUnit = datas.api_forecastDataWindDirection.api_forecastDataUnit;
        if (i < windDirectValues.count) {
            item.windDirectionFromValue = [windDirectValues objectAtIndex:i].api_forecastDataFromValue;
            item.windDirectionToValue = [windDirectValues objectAtIndex:i].api_forecastDataToValue;
        } else {
            item.windDirectionFromValue = nil;
            item.windDirectionToValue = nil;
        }
        
        item.windSpeedUnit = datas.api_forecastDataWindSpeed.api_forecastDataUnit;
        if (i < speedValues.count) {
            item.windSpeedFromValue = [speedValues objectAtIndex:i].api_forecastDataFromValue;
            item.windSpeedToValue = [speedValues objectAtIndex:i].api_forecastDataToValue;
        } else {
            item.windSpeedFromValue = nil;
            item.windSpeedToValue = nil;
        }
        
        item.pubTime = [datas.api_forecastDataPubTime stringWithFormat:HMDateFormatyyyy_MM_ddsHHcmmcss];
        item.forecastDate = [[NSDate date] dateByAddingDays:i];
        item.lastUpdateDate = [NSDate date];
        item.locationKey = locationKey;
        
        [forecasts addObject:item];
    }
    return [forecasts copy];
}

+ (NSArray<HMWeatherForecastItem *> *)forecastItemsWithDbData:(NSArray<id<HMDBWeatherForecastProtocol>> *)datas {
    NSMutableArray *forecasts = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(id<HMDBWeatherForecastProtocol>  _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
        HMWeatherForecastItem *item = [[HMWeatherForecastItem alloc] init];
        item.temperatureUnit = data.dbTemperatureUnit;
        item.temperatureFromValue = [NSString stringWithFormat:@"%ld",(long)data.dbTemperatureFromValue];
        item.temperatureToValue = [NSString stringWithFormat:@"%ld",(long)data.dbTemperatureToValue];
        if ([item.temperatureUnit isEqualToString:@"℉"]) {
            item.temperatureUnit = @"℃";
            NSInteger temperatureF = ([item.temperatureFromValue integerValue] - 32) / 1.8;
            NSInteger temperatureT = ([item.temperatureToValue integerValue] - 32) / 1.8;
            item.temperatureFromValue = [NSString stringWithFormat:@"%ld",(long)temperatureF];
            item.temperatureToValue = [NSString stringWithFormat:@"%ld",(long)temperatureT];
        }
        
        item.sunRiseFromValue = data.dbSunriseDateString;
        item.sunRiseToValue = data.dbSunsetDateString;
        item.weatherFromValue = [NSString stringWithFormat:@"%ld",(long)data.dbWeatherFromValue];
        item.weatherToValue = [NSString stringWithFormat:@"%ld",(long)data.dbWeatherToValue];
        item.pubTime = data.dbForecastPublishTime;
        item.lastUpdateDate = data.dbRecordUpdateTime;
        item.forecastDate = data.dbForecastDateTime;
        item.locationKey = data.dbLocationKey;
        
        [forecasts addObject:item];
    }];
    return [forecasts copy];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pubTime:%@ temperatureF:%@ temperatureT:%@ temperatureUnit:%@ weatherValueF:%@ weatherValueT:%@ \n",self.pubTime, self.temperatureFromValue, self.temperatureToValue, self.temperatureUnit, self.weatherFromValue, self.weatherToValue];
}

#pragma mark - db fields
// 天气数据发布时间
- (NSString *)dbForecastPublishTime {
    return self.pubTime;
}
// 天气值 from value
- (NSInteger)dbWeatherFromValue {
    return [self.weatherFromValue integerValue];
}
- (NSInteger)dbWeatherToValue {
    return [self.weatherToValue integerValue];
}

// 温度 from value
- (NSInteger)dbTemperatureFromValue {
    return [self.temperatureFromValue integerValue];
}
- (NSInteger)dbTemperatureToValue {
    return [self.temperatureToValue integerValue];
}

// 温度单位
- (NSString *)dbTemperatureUnit {
    return self.temperatureUnit;
}
// 数据库记录更新时间
- (NSDate *)dbRecordUpdateTime {
    return [NSDate date];
}
// 日落时间
- (NSString *)dbSunsetDateString {
    return self.sunRiseToValue;
}
// 日出时间
- (NSString *)dbSunriseDateString {
    return self.sunRiseFromValue;
}
// 预报对应的日期
- (NSDate *)dbForecastDateTime {
    return self.forecastDate;
}
// 行政区key
- (NSString *)dbLocationKey {
    return self.locationKey;
}

#pragma mark - 返回的数据结构
// eg link: https://weatherapi.market.xiaomi.com/wtr-v3/weather/forecast/daily?appKey=watch20161010&days=7&isGlobal=false&locale=zh_CN&locationKey=weathercn%3A101010100&sign=j9PMzsOIAw0bN8eE
/*{
    status = 0;
    precipitationProbability = {
        status = 0;
        value = (
                 0,
                 1,
                 16,
                 3,
                 25,
                 );
    }
    ;
    sunRiseSet = {
        status = 0;
        value = (
                 {
                     to = 2018-01-05T16:42:00+08:00;
                     from = 2018-01-05T07:24:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-06T17:04:00+08:00;
                     from = 2018-01-06T07:36:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-07T17:05:00+08:00;
                     from = 2018-01-07T07:36:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-08T17:06:00+08:00;
                     from = 2018-01-08T07:36:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-09T17:07:00+08:00;
                     from = 2018-01-09T07:36:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-10T17:08:00+08:00;
                     from = 2018-01-10T07:36:00+08:00;
                 }
                 ,
                 {
                     to = 2018-01-11T17:09:00+08:00;
                     from = 2018-01-11T07:35:00+08:00;
                 }
                 ,
                 );
    }
    ;
    wind = {
        speed = {
            status = 0;
            value = (
                     {
                         to = 15.5;
                         from = 15.5;
                     }
                     ,
                     {
                         to = 15.5;
                         from = 15.5;
                     }
                     ,
                     {
                         to = 15.5;
                         from = 15.5;
                     }
                     ,
                     {
                         to = 33.5;
                         from = 33.5;
                     }
                     ,
                     {
                         to = 24.0;
                         from = 24.0;
                     }
                     ,
                     {
                         to = 15.5;
                         from = 15.5;
                     }
                     ,
                     {
                         to = 15.5;
                         from = 15.5;
                     }
                     ,
                     );
            unit = km/h;
        }
        ;
        direction = {
            status = 0;
            value = (
                     {
                         to = 225;
                         from = 225;
                     }
                     ,
                     {
                         to = 45;
                         from = 45;
                     }
                     ,
                     {
                         to = 225;
                         from = 225;
                     }
                     ,
                     {
                         to = 315;
                         from = 315;
                     }
                     ,
                     {
                         to = 315;
                         from = 315;
                     }
                     ,
                     {
                         to = 315;
                         from = 315;
                     }
                     ,
                     {
                         to = 225;
                         from = 225;
                     }
                     ,
                     );
            unit = °;
        }
        ;
    }
    ;
    aqi = {
        brandInfo = {
            brands = (
                      {
                          brandId = caiyun;
                          names = {
                              en_US = 彩云天气;
                              zh_TW = 彩雲天氣;
                              zh_CN = 彩云天气;
                          }
                          ;
                          url = ;
                          logo = http://f5.market.mi-img.com/download/MiSafe/07fa34263d698a7a9a8050dde6a7c63f8f243dbf3/a.webp;
                      }
                      ,
                      );
        }
        ;
        status = 0;
        pubTime = 2018-01-05T00:00:00+08:00;
        value = (
                 49,
                 65,
                 156,
                 38,
                 22,
                 55,
                 100,
                 );
    }
    ;
    temperature = {
        status = 0;
        value = (
                 {
                     to = -7;
                     from = 4;
                 }
                 ,
                 {
                     to = -4;
                     from = 2;
                 }
                 ,
                 {
                     to = -4;
                     from = 3;
                 }
                 ,
                 {
                     to = -7;
                     from = 3;
                 }
                 ,
                 {
                     to = -8;
                     from = 1;
                 }
                 ,
                 {
                     to = -8;
                     from = 0;
                 }
                 ,
                 {
                     to = -8;
                     from = 1;
                 }
                 ,
                 );
        unit = ℃;
    }
    ;
    weather = {
        status = 0;
        value = (
                 {
                     to = 0;
                     from = 1;
                 }
                 ,
                 {
                     to = 2;
                     from = 1;
                 }
                 ,
                 {
                     to = 1;
                     from = 2;
                 }
                 ,
                 {
                     to = 0;
                     from = 0;
                 }
                 ,
                 {
                     to = 0;
                     from = 0;
                 }
                 ,
                 {
                     to = 0;
                     from = 0;
                 }
                 ,
                 {
                     to = 0;
                     from = 0;
                 }
                 ,
                 );
    }
    ;
    pubTime = 2018-01-05T14:40:00+08:00;
}*/
@end
