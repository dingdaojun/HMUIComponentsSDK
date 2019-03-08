//  HMServiceApiWeatherProtocol.h
//  Created on 2018/1/4
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <CoreLocation/CoreLocation.h>

#ifndef HMServiceApiWeatherProtocol_h
#define HMServiceApiWeatherProtocol_h


#pragma mark - 天气location的消息
@protocol HMServiceAPIWeatherLocationData <NSObject>

@property (readonly)   NSString                *api_locationDataKey;           // key值
@property (readonly)   NSString                *api_locationDataAffiliation;   // 位置的具体信息
@property (readonly)   NSString                *api_locationDataName;          // 区域名称
@property (readonly) CLLocationCoordinate2D    api_locationDataCoordinate;     // 经纬度
@property (readonly) BOOL                      api_locationDataStatus;         // 状态信息

@end

#pragma mark - 天气预报信息
@protocol HMServiceAPIWeatherForecastDataValueProtocol <NSObject>

@property (readonly) NSString      *api_forecastDataFromValue;
@property (readonly) NSString      *api_forecastDataToValue;

@end

@protocol HMServiceAPIWeatherForecastDataProtocol <NSObject>

@property (readonly) NSArray<id<HMServiceAPIWeatherForecastDataValueProtocol>> *api_forecastDataValues;
@property (readonly) NSString      *api_forecastDataUnit;

@end

@protocol HMServiceAPIWeatherForecastSunRiseSetProtocol <NSObject>

@property (readonly) NSDate      *api_forecastSunriseDate; //日出时间
@property (readonly) NSDate      *api_forecastSunsetDate;  //日落时间

@end


@protocol HMServiceAPIWeatherForecastData <NSObject>

@property (readonly) NSArray<id<HMServiceAPIWeatherForecastSunRiseSetProtocol>>  *api_forecastDataSunRiseSet;

@property (readonly) NSArray                                       *api_forecastDataAqi;

@property (readonly) id<HMServiceAPIWeatherForecastDataProtocol>   api_forecastDataWindDirection;

@property (readonly) id<HMServiceAPIWeatherForecastDataProtocol>   api_forecastDataWindSpeed;

@property (readonly) id<HMServiceAPIWeatherForecastDataProtocol>   api_forecastDataTemperature;

@property (readonly) id<HMServiceAPIWeatherForecastDataProtocol>   api_forecastDataWeather;

@property (readonly)  NSDate                                       *api_forecastDataPubTime;

@end


#pragma mark - 天气实时信息
@protocol HMServiceAPIWeatherRealTimeDataProtocol <NSObject>

@property (readonly) NSString  *api_realTimeDataValue;
@property (readonly) NSString  *api_realTimeDataUnit;

@end

@protocol HMServiceAPIWeatherRealTimeData <NSObject>


@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataVisibility;         // 能见度

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataHumidity;           // 湿度

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataWindSpeed;          // 风速

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataWindDirection;      // 风向

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataFeelsLike;          // 体感温度

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataPressure;           // 气压

@property (readonly) id<HMServiceAPIWeatherRealTimeDataProtocol>   api_realTimeDataTemperature;        // 温度

@property (readonly)  NSDate       *api_realTimeDataPubTime;
@property (readonly) NSInteger   api_realTimeDataWeather;
@property (readonly) NSInteger   api_realTimeDataUVIndex;

@end

#pragma mark - 空气质量信息
@protocol HMServiceAPIWeatherAirQualityData <NSObject>

@property (readonly)   NSDate      *api_airQualityDataPubTime;     // 更新时间

@property (readonly) NSInteger   api_airQualityDataAQI;

@property (readonly) float       api_airQualityDataCO;

@property (readonly) NSInteger   api_airQualityDataNO2;

@property (readonly) NSInteger   api_airQualityDataO3;

@property (readonly) NSInteger   api_airQualityDataPM10;

@property (readonly) NSInteger   api_airQualityDataPM25;

@property (readonly) NSInteger   api_airQualityDataSO2;

@property (readonly)   NSString    *api_airQualityDataPrimary;

@property (readonly)   NSString    *api_airQualityDataSource;      // 数据来源

@end

#pragma mark - 天气预警信息
@protocol HMServiceAPIWeatherWarningData <NSObject>


@property (readonly) NSDate        *api_weatherWarningDataPubTime;     // 更新时间
@property (readonly) NSString      *api_weatherWarningDataAlertID;
@property (readonly) NSString      *api_weatherWarningDataTitle;
@property (readonly) NSString      *api_weatherWarningDataType;    // 类型
@property (readonly) NSString      *api_weatherWarningDataLevel;   // 等级
@property (readonly) NSString      *api_weatherWarningDataDetail;  // 详情
@property (readonly) NSDictionary  *api_weatherWarningDataImages;

@end


#endif /* HMServiceApiWeatherProtocol_h */
