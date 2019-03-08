//  HMServiceAPI+Weather.m
//  Created on 2018/1/3
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Weather.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

static NSString *mifitAppWeatherAppKey  = @"watch20161010";
static NSString *mifitAppWeatherSign    = @"j9PMzsOIAw0bN8eE";


@interface NSString (WeatherDate)
- (NSDate *)generateWeatherDate;
@end

@implementation NSString (WeatherDate)

- (NSDate *)generateWeatherDate {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *destDate = [dateFormatter dateFromString:self];

    return destDate;
}

@end


#pragma mark - 天气location信息
#pragma mark - 天气预报信息
@interface NSDictionary (HMServiceAPIWeatherLocationData) <HMServiceAPIWeatherLocationData>
@end

@implementation NSDictionary (HMServiceAPIWeatherLocationData)

- (NSString *)api_locationDataKey {
    return self.hmjson[@"locationKey"].string;
}

- (NSString *)api_locationDataAffiliation {
    return self.hmjson[@"affiliation"].string;
}

- (NSString *)api_locationDataName {
    return self.hmjson[@"name"].string;
}


- (CLLocationCoordinate2D)api_locationDataCoordinate {

    double latitude = self.hmjson[@"latitude"].doubleValue;
    double longitude = self.hmjson[@"longitude"].doubleValue;
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (BOOL)api_locationDataStatus {
    return !self.hmjson[@"status"].boolean;
}

@end


#pragma mark - 天气预报信息
@interface NSDictionary (HMServiceAPIWeatherForecastDataValueProtocol) <HMServiceAPIWeatherForecastDataValueProtocol>
@end

@implementation NSDictionary (HMServiceAPIWeatherForecastDataValueProtocol)

- (NSString *)api_forecastDataFromValue {
    return self.hmjson[@"from"].string;
}

- (NSString *)api_forecastDataToValue {
    return self.hmjson[@"to"].string;
}

@end


@interface NSDictionary (HMServiceAPIWeatherForecastDataProtocol) <HMServiceAPIWeatherForecastDataProtocol>
@end

@implementation NSDictionary (HMServiceAPIWeatherForecastDataProtocol)

- (NSArray<id<HMServiceAPIWeatherForecastDataValueProtocol>> *)api_forecastDataValues {
    return self.hmjson[@"value"].array;
}

- (NSString *)api_forecastDataUnit {
    return self.hmjson[@"unit"].string;
}

@end



@interface NSDictionary (HMServiceAPIWeatherForecastSunRiseSetProtocol) <HMServiceAPIWeatherForecastSunRiseSetProtocol>
@end

@implementation NSDictionary (HMServiceAPIWeatherForecastSunRiseSetProtocol)

- (NSDate *)api_forecastSunriseDate {
    return [self.hmjson[@"from"].string generateWeatherDate];
}

- (NSDate *)api_forecastSunsetDate {
    return [self.hmjson[@"to"].string generateWeatherDate];
}

@end

@interface NSDictionary (HMServiceAPIWeatherForecastData) <HMServiceAPIWeatherForecastData>
@end

@implementation NSDictionary (HMServiceAPIWeatherForecastData)

- (NSArray *)api_forecastDataAqi {
    NSDictionary *aqiData = self.hmjson[@"aqi"].dictionary;
    return aqiData.hmjson[@"value"].array;
}

- (id<HMServiceAPIWeatherForecastDataProtocol>)api_forecastDataWindDirection {
    NSDictionary *windData = self.hmjson[@"wind"].dictionary;
    return windData.hmjson[@"direction"].dictionary;
}

- (id<HMServiceAPIWeatherForecastDataProtocol>)api_forecastDataWindSpeed {
    NSDictionary *windData = self.hmjson[@"wind"].dictionary;
    return windData.hmjson[@"speed"].dictionary;
}

- (id<HMServiceAPIWeatherForecastDataProtocol>)api_forecastDataTemperature {
    return self.hmjson[@"temperature"].dictionary;
}

- (id<HMServiceAPIWeatherForecastDataProtocol>)api_forecastDataWeather {
    return self.hmjson[@"weather"].dictionary;
}

- (NSDate *)api_forecastDataPubTime {
    NSString *date = self.hmjson[@"pubTime"].string;
    return [date generateWeatherDate];
}

- (NSArray<id<HMServiceAPIWeatherForecastSunRiseSetProtocol>> *)api_forecastDataSunRiseSet {
    NSDictionary *sunRiseSet = self.hmjson[@"sunRiseSet"].dictionary;
    return sunRiseSet.hmjson[@"value"].array;
}

@end



#pragma mark - 天气实时信息
@interface NSDictionary (HMServiceAPIWeatherRealTimeDataProtocol) <HMServiceAPIWeatherRealTimeDataProtocol>
@end

@implementation NSDictionary (HMServiceAPIWeatherRealTimeDataProtocol)

- (NSString *)api_realTimeDataValue {
    return self.hmjson[@"value"].string;
}

- (NSString *)api_realTimeDataUnit {
    return self.hmjson[@"unit"].string;
}

@end


@interface NSDictionary (HMServiceAPIWeatherRealTimeData) <HMServiceAPIWeatherRealTimeData>
@end

@implementation NSDictionary (HMServiceAPIWeatherRealTimeData)

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataVisibility {
    return self.hmjson[@"visibility"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataHumidity {
    return self.hmjson[@"humidity"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataWindSpeed {

    NSDictionary *windData = self.hmjson[@"wind"].dictionary;
    return windData.hmjson[@"speed"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataWindDirection {
    NSDictionary *windData = self.hmjson[@"wind"].dictionary;
    return windData.hmjson[@"direction"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataFeelsLike {
    return self.hmjson[@"feelsLike"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataPressure {
    return self.hmjson[@"pressure"].dictionary;
}

- (id<HMServiceAPIWeatherRealTimeDataProtocol>)api_realTimeDataTemperature {
    return self.hmjson[@"temperature"].dictionary;
}

- (NSDate *)api_realTimeDataPubTime {
    return self.hmjson[@"pubTime"].date;
}

- (NSInteger)api_realTimeDataWeather {
    return self.hmjson[@"weather"].integerValue;
}

- (NSInteger)api_realTimeDataUVIndex {
    return self.hmjson[@"uvIndex"].integerValue;
}

@end

#pragma mark - 空气质量信息
@interface NSDictionary (HMServiceAPIWeatherAirQualityData) <HMServiceAPIWeatherAirQualityData>
@end

@implementation NSDictionary (HMServiceAPIWeatherAirQualityData)

- (NSInteger)api_airQualityDataAQI {
    return self.hmjson[@"aqi"].integerValue;
}

- (float)api_airQualityDataCO {
    return self.hmjson[@"co"].floatValue;
}

- (NSInteger)api_airQualityDataNO2 {
    return self.hmjson[@"no2"].integerValue;
}

- (NSInteger)api_airQualityDataO3 {
    return self.hmjson[@"o3"].integerValue;
}

- (NSInteger)api_airQualityDataPM10 {
    return self.hmjson[@"pm10"].integerValue;
}

- (NSInteger)api_airQualityDataPM25 {
    return self.hmjson[@"pm25"].integerValue;
}

- (NSInteger)api_airQualityDataSO2 {
    return self.hmjson[@"so2"].integerValue;
}

- (NSString *)api_airQualityDataPrimary {
    return self.hmjson[@"primary"].string;
}

- (NSString *)api_airQualityDataSource {
    return self.hmjson[@"src"].string;
}

- (NSDate *)api_airQualityDataPubTime {

    NSString *date = self.hmjson[@"pubTime"].string;
    return [date generateWeatherDate];
}

@end




#pragma mark - 天气预警信息
@interface NSDictionary (HMServiceAPIWeatherWarningData) <HMServiceAPIWeatherWarningData>
@end

@implementation NSDictionary (HMServiceAPIWeatherWarningData)

- (NSDate *)api_weatherWarningDataPubTime {
    NSString *date = self.hmjson[@"pubTime"].string;
    return [date generateWeatherDate];
}

- (NSString *)api_weatherWarningDataAlertID {
    return self.hmjson[@"alertId"].string;
}

- (NSString *)api_weatherWarningDataTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_weatherWarningDataType {
    return self.hmjson[@"type"].string;
}

- (NSString *)api_weatherWarningDataLevel {
    return self.hmjson[@"level"].string;
}

- (NSString *)api_weatherWarningDataDetail {
    return self.hmjson[@"detail"].string;
}

- (NSDictionary *)api_weatherWarningDataImages {
    return self.hmjson[@"images"].dictionary;
}

@end

@implementation HMServiceAPI (Weather)

- (id<HMCancelableAPI>)weather_locationDataWithCoordination:(CLLocationCoordinate2D)coordinate
                                                   isGlobal:(BOOL)isGlobal
                                            completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/location/city/geo";
        NSMutableDictionary *parameters = [@{@"latitude": @(coordinate.latitude),
                                             @"longitude": @(coordinate.longitude),
                                             @"locale": [self getCurrentLanguageStr],
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForResponseObject:responseObject
                                            responseError:error
                                          completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas) {

                                              id<HMServiceAPIWeatherLocationData> locationData = nil;
                                              if (locationDatas.count > 0) {
                                                  locationData = [locationDatas firstObject];
                                              }
                                              completionBlock(success, message, locationData);
                                          }];
                  }];
    }];
}

- (id<HMCancelableAPI>)weather_locationDataWithCityName:(NSString *)cityName
                                               isGlobal:(BOOL)isGlobal
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas))completionBlock {

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{
        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/location/city/search";
        NSMutableDictionary *parameters = [@{@"name": cityName,
                                             @"locale": [self getCurrentLanguageStr],
                                             @"appKey": mifitAppWeatherAppKey,
                                             @"sign": mifitAppWeatherSign,
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];
        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self handleResultForResponseObject:responseObject
                                            responseError:error
                                          completionBlock:completionBlock];
                  }];
    }];
}

- (void)handleResultForResponseObject:(id)responseObject
                        responseError:(NSError *)responseError
                      completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas))completionBlock {

    if (responseError) {
        completionBlock(NO, responseError.localizedDescription, nil);
        return;
    }
    
    NSArray *items = (NSArray *)responseObject;
    if (!items || ![items isKindOfClass:[NSArray class]] || items.count == 0) {
        completionBlock(YES, nil, nil);
        return;
    }

    completionBlock(YES, nil, items);
}

- (id<HMCancelableAPI>)weather_realTimeDataWithLocationKey:(NSString *)locationKey
                                                  isGlobal:(BOOL)isGlobal
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherRealTimeData> realTimeData))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/weather/current";
        NSMutableDictionary *parameters = [@{@"locationKey": locationKey,
                                             @"locale": [self getCurrentLanguageStr],
                                             @"appKey": mifitAppWeatherAppKey,
                                             @"sign": mifitAppWeatherSign,
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      if (error) {
                          completionBlock(NO, error.localizedDescription, nil);
                          return;
                      }

                      NSDictionary *data = (NSDictionary *)responseObject;
                      if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                          completionBlock(NO, nil, nil);
                          return;
                      }
                      
                      completionBlock(YES, nil, data);
                  }];
    }];
}

- (id<HMCancelableAPI>)weather_forecastDataWithLocationKey:(NSString *)locationKey
                                                  isGlobal:(BOOL)isGlobal
                                                      days:(NSInteger)days
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherForecastData> forecastData))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/weather/forecast/daily";
        NSMutableDictionary *parameters = [@{@"locationKey": locationKey,
                                             @"days": @(days),
                                             @"locale": [self getCurrentLanguageStr],
                                             @"appKey": mifitAppWeatherAppKey,
                                             @"sign": mifitAppWeatherSign,
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      if (error) {
                          completionBlock(NO, error.localizedDescription, nil);
                          return;
                      }
                      
                      NSDictionary *data = (NSDictionary *)responseObject;
                      if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                          completionBlock(NO, nil, nil);
                          return;
                      }

                      completionBlock(YES, nil, data);
                  }];
    }];
}

- (id<HMCancelableAPI>)weather_airQualityDataWithLocationKey:(NSString *)locationKey
                                                    isGlobal:(BOOL)isGlobal
                                             completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherAirQualityData> airQualityData))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/weather/aqi/current";
        NSMutableDictionary *parameters = [@{@"locationKey": locationKey,
                                             @"locale": [self getCurrentLanguageStr],
                                             @"appKey": mifitAppWeatherAppKey,
                                             @"sign": mifitAppWeatherSign,
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      if (error) {
                          completionBlock(NO, error.localizedDescription, nil);
                          return;
                      }

                      NSDictionary *data = (NSDictionary *)responseObject;
                      if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                          completionBlock(NO, nil, nil);
                          return;
                      }

                      completionBlock(YES, nil, data);
                  }];
    }];
}

- (id<HMCancelableAPI>)weather_weatherWarningDataWithLocationKey:(NSString *)locationKey
                                                        isGlobal:(BOOL)isGlobal
                                                 completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWeatherWarningData> weatherWarningData))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = @"https://weatherapi.market.xiaomi.com/wtr-v3/weather/alerts";
        NSMutableDictionary *parameters = [@{@"locationKey": locationKey,
                                             @"locale": [self getCurrentLanguageStr],
                                             @"appKey": mifitAppWeatherAppKey,
                                             @"sign": mifitAppWeatherSign,
                                             @"isGlobal": isGlobal ? @"true" : @"false"} mutableCopy];

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:nil
                          timeout:30
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      if (error) {
                          completionBlock(NO, error.localizedDescription, nil);
                          return;
                      }

                      NSDictionary *warningData = nil;
                      if (responseObject) {
                          NSDictionary *dictionary = (NSDictionary *)responseObject;
                          NSArray *warningDatas = dictionary.hmjson[@"alerts"].array;
                          if (warningDatas.count > 0) {
                              warningData = [warningDatas firstObject];
                          }
                      }

                      completionBlock(YES, nil, warningData);
                  }];
    }];
}

- (NSString *)getCurrentLanguageStr {

    NSLocale *curLocale = [NSLocale currentLocale];
    NSString *contryCode = [curLocale objectForKey:NSLocaleCountryCode];
    NSString *languageCode = [curLocale objectForKey:NSLocaleLanguageCode];

    if (contryCode.length == 0) {
        contryCode = @"CN";
    }
    if (languageCode.length == 0) {
        languageCode = @"zh";
    }
    return [NSString stringWithFormat:@"%@_%@", languageCode, contryCode];
}
@end
