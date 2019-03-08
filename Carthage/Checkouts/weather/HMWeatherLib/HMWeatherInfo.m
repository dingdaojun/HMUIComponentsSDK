//  HMWeatherInfo.m
//  Created on 2018/1/5
//  Description 天气数据info

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "HMWeatherInfo.h"
@import ReactiveObjC;
@import WeatherService.HMServiceAPI_Weather;
@import HMCategory;
@import HMDBWeather;
@import HMLog;

static NSString *mifitAppWeatherAppKey  = @"watch20161010";
static NSString *mifitAppWeatherSign    = @"j9PMzsOIAw0bN8eE";

static NSString *userDefaultLocationKey         = @"W-locationKey";// 设备端天气locationKey
static NSString *userSportLocationKey           = @"S-locationKey";// 训练中心天气数据locationKey
static NSString *userSunRiseUpdateDate          = @"SunRiseUpdateDate";// 日出日落数据更新时间key
static NSString *userSunRiseData                = @"SunRiseData";// 日出日落数据key
static NSString *userDefalutLastLocation        = @"W-LocationItem";
static NSString *version1_TO_2                  = @"weather_version1_TO_2";// 天气数据库version1_TO_2操作
static NSString *userDefaultSuiteName           = @"HMWeather";

typedef NS_ENUM(NSUInteger, HMWeatherInfoType) {
    HMWeatherInfoTypeAlert,     //预警
    HMWeatherInfoTypeCurrent,   //实时
    HMWeatherInfoTypeAQI,       //AQI
    HMWeatherInfoTypeForecast,  //天气预报
};

@interface HMWeatherInfo ()

@property (nonatomic, assign) NSInteger ForecastDays;// 请求的天气预报days (默认 7 天)
@property (nonatomic, assign) NSInteger RequestForecastHours;// 请求天气预报相隔hours (默认 8 小时)
@property (nonatomic, assign) NSInteger LocationMargin;// 定位距离间隔 1km.(修改为 2km.)
@property (nonatomic, assign) NSInteger AQIUpdateHours;// 实时，AQI，预警 (默认 每 1 小时更新)

@property (nonatomic, strong) HMDBWeatherService *dbWeatherService;
@property (nonatomic, strong) NSUserDefaults *weatherUserDefaults;
/**
 避免多次请求(卸载重装时候)
 */
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation HMWeatherInfo

+ (instancetype)shareInfo {
    static HMWeatherInfo* __defaultShareInstance;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        __defaultShareInstance = [[HMWeatherInfo alloc] init];
    });
    return __defaultShareInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ForecastDays = 7;
        _RequestForecastHours = 8;
        _LocationMargin = 2;
        _AQIUpdateHours = 1;
        _dbWeatherService = [[HMDBWeatherService alloc] init];
        _isRequesting = NO;
        _weatherUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:userDefaultSuiteName];
    }
    return self;
}

- (void)setWeatherConfig:(HMWeatherConfig *)weatherConfig {
    _weatherConfig = weatherConfig;
    // 更新各个数据时间间隔
    self.AQIUpdateHours = weatherConfig.AQIUpdateHours;
    self.RequestForecastHours = weatherConfig.forecastUpdateHours;
    self.LocationMargin = weatherConfig.LocationKeyUpdateDistance;
}

#pragma mark - public func

- (HMWeatherAirQualityItem * __nullable)currentAQIForDevice:(BOOL)supportDevice {
    NSString *locationKey = supportDevice ? [self.weatherUserDefaults objectForKey:userDefaultLocationKey] : [self.weatherUserDefaults objectForKey:userSportLocationKey];
    return [self getAirQualityItemWithLocatinKey:locationKey];
}

- (HMWeatherAlertItem * __nullable)currentAlertForDevice:(BOOL)supportDevice {
    NSString *locationKey = supportDevice ? [self.weatherUserDefaults objectForKey:userDefaultLocationKey] : [self.weatherUserDefaults objectForKey:userSportLocationKey];
    return [self getAlertItemWithLocatinKey:locationKey];
}

- (NSArray<HMWeatherForecastItem *> * __nullable)currentForecastForDevice:(BOOL)supportDevice {
    NSString *locationKey = supportDevice ? [self.weatherUserDefaults objectForKey:userDefaultLocationKey] : [self.weatherUserDefaults objectForKey:userSportLocationKey];
    return [self getForecastItemWithLocatinKey:locationKey];
}

- (HMWeatherCurrentItem * __nullable)currentRealDataForDevice:(BOOL)supportDevice {
    NSString *locationKey = supportDevice ? [self.weatherUserDefaults objectForKey:userDefaultLocationKey] : [self.weatherUserDefaults objectForKey:userSportLocationKey];
    return [self getCurrentWeatherItemWithLocatinKey:locationKey];
}

- (HMWeatherCurrentItem *)getCurrentWeatherItemWithLocatinKey:(NSString *)locationKey {
    id<HMDBCurrentWeatherProtocol> currentWeather = [self.dbWeatherService currentWeatherAt:locationKey];
    if (!currentWeather) {
        HMLogW(weather, @"weather database RealWeather data is Null.");
        return nil;
    }
    if ([currentWeather.dbRecordUpdateTime secondsBeforeDate:[NSDate date]] > 2 * 60 * 60) {
        HMLogW(weather, @"current weather data before 2hours ago.");
        return nil;
    }
    return [[HMWeatherCurrentItem alloc] initWithDBRealTimeData:currentWeather];
}

- (HMWeatherAirQualityItem *)getAirQualityItemWithLocatinKey:(NSString *)locationKey {
    id<HMDBWeatherAQIProtocol> currentAQI = [self.dbWeatherService currentAQIAt:locationKey];
    if (!currentAQI) {
        HMLogW(weather, @"weather database AQI data is Null.");
        return nil;
    }
    if ([currentAQI.dbRecordUpdateTime secondsBeforeDate:[NSDate date]] > 2 * 60 * 60) {
        HMLogW(weather, @"aqi weather data before 2hours ago.");
        return nil;
    }
    return [[HMWeatherAirQualityItem alloc] initWithDBAqiData:currentAQI];
}

- (HMWeatherAlertItem *)getAlertItemWithLocatinKey:(NSString *)locationKey {
    id<HMDBWeatherEarlyWarningProtocol> currentWarning = [self.dbWeatherService earlyWarningAt:locationKey];
    if (!currentWarning) {
        HMLogW(weather, @"weather database Warning data is Null.");
        return nil;
    }
    if ([currentWarning.dbRecordUpdateTime secondsBeforeDate:[NSDate date]] > 2 * 60 * 60) {
        HMLogW(weather, @"alert weather data before 2hours ago.");
        return nil;
    }
    return [[HMWeatherAlertItem alloc] initWithDBWarningData:currentWarning];
}

- (HMWeatherLocationItem * __nullable)getLastLocationItem {
    HMWeatherLocationItem *item = [HMWeatherLocationItem fromStoreObj:[self.weatherUserDefaults objectForKey:userDefalutLastLocation]];
    return item;
}

- (id<HMWeatherSunRiseSetItemProtocol> __nullable)curSunRiseSetWithAutoLocate:(BOOL)isAutoLocate {
    // 设备端选择手动城市，需要获取当前定位下的日出日落数据
    HMWeatherSunRiseSet *sunRiseItem = nil;
    if (!isAutoLocate) {
        NSArray *sunRiseSet = [self.weatherUserDefaults objectForKey:userSunRiseData];
        for (NSDictionary *item in sunRiseSet) {
            NSDate *fromDate = [self dateFromWeatherTimeStr:[item objectForKey:@"from"]];
            if (fromDate.day == [NSDate date].day) {
                sunRiseItem = [[HMWeatherSunRiseSet alloc] initWithSunRiseItem:item];
                break;
            }
        }
        return sunRiseItem;
    }
    NSArray<HMWeatherForecastItem *> *forecasts = [self currentForecastForDevice:YES];
    for (HMWeatherForecastItem *forecast in forecasts) {
        if (forecast.forecastDate.day == [NSDate date].day) {
            sunRiseItem = [[HMWeatherSunRiseSet alloc] initWithForecast:forecast];
            break;
        }
    }
    return sunRiseItem;
}

- (NSArray<HMWeatherForecastItem *> *)getForecastItemWithLocatinKey:(NSString *)locationKey {
    NSArray<id<HMDBWeatherForecastProtocol>> *allForecasts = [self.dbWeatherService weatherForecastAt:locationKey];
    HMLogD(weather, @"all weather forecast count: %lu",(unsigned long)allForecasts.count);
    if (!allForecasts) {
        HMLogW(weather, @"weather database Foreacst data is Null.");
        return nil;
    }
    if ([allForecasts.firstObject.dbRecordUpdateTime secondsBeforeDate:[NSDate date]] > 24 * 60 * 60) {
        HMLogW(weather, @"forecasts weather data before 24 hours ago.");
        return nil;
    }
    return [HMWeatherForecastItem forecastItemsWithDbData:allForecasts];
}

- (BOOL)cleanWeatherData {
    BOOL AQIStatus = [self.dbWeatherService removeAllAQI];
    BOOL EarlyWStatus = [self.dbWeatherService removeAllEarlyWarning];
    BOOL CurStatus = [self.dbWeatherService removeAllCurrentWeather];
    BOOL ForecastStatus = [self.dbWeatherService removeAllWeatherForecast];
    HMLogD(weather, @"weather_info , 清除之前city的所有天气数据,removeAQI: %d ,removeEarly: %d, removeCur: %d, removeForecast: %d",AQIStatus,EarlyWStatus,CurStatus,ForecastStatus);
    return (AQIStatus && EarlyWStatus && CurStatus && ForecastStatus);
}

- (void)cleanWeatherDataBase {
    NSError *error = [HMDBWeatherBaseConfig clearDatabase];
    if (error) {
        HMLogE(weather, @"删除weather 数据库失败");
    }
}

#pragma mark - 日出/日落数据只能在天气预报里面才有
- (void)fetchSunRiseWithCoordination:(CLLocationCoordinate2D)coordinate
                            isGlobal:(BOOL)isGlobal
                          completion:(void (^)(BOOL isSuccess, BOOL isUpdate))completion {
    NSDate *lastSunriseTime = [self.weatherUserDefaults objectForKey:userSunRiseUpdateDate];
    NSArray *lastSunRiseData = [self.weatherUserDefaults objectForKey:userSunRiseData];
    // 更新频率和天气预报一致.
    if (!lastSunRiseData || [lastSunriseTime secondsBeforeDate:[NSDate date]] > self.RequestForecastHours * 60 * 60) {
        [[HMServiceAPI defaultService] weather_locationDataWithCoordination:coordinate isGlobal:isGlobal completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData) {
            if (!success) {
                HMLogW(weather, @"fetch sunRise location key get error: %@",message);
                completion(NO, nil);
                return ;
            }
            NSString *key = locationData.api_locationDataKey;
            if (!key.length) {
                completion(NO, nil);
                HMLogW(weather, @"get sunRise locationKey is nil.");
                return;
            }
            @weakify(self);
            [self getWeatherInfoWithType:HMWeatherInfoTypeForecast locationKey:key isGlobal:isGlobal Success:^(id weatherData) {
                @strongify(self);
                id<HMServiceAPIWeatherForecastData> forecastData = weatherData;
                HMLogD(weather, @"sunRise data : %@",forecastData.api_forecastDataSunRiseSet);
                [self.weatherUserDefaults setObject:forecastData.api_forecastDataSunRiseSet forKey:userSunRiseData];
                [self.weatherUserDefaults setObject:[NSDate date] forKey:userSunRiseUpdateDate];
                [self.weatherUserDefaults synchronize];
                completion(YES, YES);
            } Fail:^(NSString *message) {
                HMLogW(weather, @"fetch sunRise error: %@",message);
                completion(NO, NO);
            }];
        }];
    } else {
        completion(YES,NO);
    }
}
                
- (void)fetchLocationItemWithCoordination:(CLLocationCoordinate2D)coordinate
                                 isGlobal:(BOOL)isGlobalUser
                               completion:(void (^)(BOOL))completion {
    @weakify(self);
    [self fetchLocation:coordinate isGlobal:isGlobalUser success:^(id<HMServiceAPIWeatherLocationData> locationData) {
        @strongify(self);
        HMWeatherLocationItem *item = [[HMWeatherLocationItem alloc] initWithLocation:locationData];
        item.currentLongitude = coordinate.longitude;
        item.currentLatitude = coordinate.latitude;
        [self.weatherUserDefaults setObject:item.storeObj forKey:userDefalutLastLocation];
        completion(YES);
    } fail:^{
        completion(NO);
    }];
}

- (void)fetchAqiWithCoordination:(CLLocationCoordinate2D)coordinate
                        isGlobal:(BOOL)isGlobalUser
                      completion:(void (^)(BOOL success, HMWeatherAirQualityItem * __nullable aqi))completion {
    HMWeatherAirQualityItem *aqiData = [self currentAQIForDevice:NO];
    if (!aqiData || [aqiData.lastUpdateDate secondsBeforeDate:[NSDate date]] > self.AQIUpdateHours * 60 * 60) {
        [[HMServiceAPI defaultService] weather_locationDataWithCoordination:coordinate isGlobal:isGlobalUser completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData) {
            if (!success) {
                HMLogW(weather, @"fetch aqi location key get error: %@",message);
                completion(NO, nil);
                return ;
            }
            NSString *key = locationData.api_locationDataKey;
            if (!key.length) {
                completion(NO, nil);
                return ;
            }
            // 训练中心 locationKey
            [self.weatherUserDefaults setObject:key forKey:userSportLocationKey];
            [self.weatherUserDefaults synchronize];
            
            @weakify(self);
            [self getWeatherInfoWithType:HMWeatherInfoTypeAQI locationKey:key isGlobal:isGlobalUser Success:^(id weatherData) {
                @strongify(self);
                id<HMServiceAPIWeatherAirQualityData> aqiData = weatherData;
                HMWeatherAirQualityItem *aqiItem = [[HMWeatherAirQualityItem alloc] initWithAQIData:aqiData locationKey:key];
                NSError *error = [self.dbWeatherService addOrUpdateAQIRecord:aqiItem];
                if (error) {
                    HMLogW(weather, @"fetch Aqi add or update error: %@",error);
                }
                completion(YES, aqiItem);
            } Fail:^(NSString *message) {
                HMLogW(weather, @"fetch aqi error: %@",message);
                completion(NO, nil);
            }];
        }];
    } else {
        completion(YES, aqiData);
    }
}

- (void)fetchCurWeatherWithCoordination:(CLLocationCoordinate2D)coordinate
                               isGloabl:(BOOL)isGlobalUser
                             completion:(void (^)(BOOL success, HMWeatherCurrentItem * __nullable aqi))completion {
    HMWeatherCurrentItem *curWeather = [self currentRealDataForDevice:NO];
    
    if (!curWeather || [curWeather.lastUpdateDate secondsBeforeDate:[NSDate date]] > self.AQIUpdateHours * 60 * 60) {
        [[HMServiceAPI defaultService] weather_locationDataWithCoordination:coordinate isGlobal:isGlobalUser completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData) {
            if (!success) {
                HMLogW(weather, @"fetch cur weather location key get error: %@",message);
                completion(NO, nil);
                return ;
            }
            NSString *key = locationData.api_locationDataKey;
            if (!key.length) {
                completion(NO, nil);
                return ;
            }
            // 训练中心 locationKey
            [self.weatherUserDefaults setObject:key forKey:userSportLocationKey];
            [self.weatherUserDefaults synchronize];
            
            @weakify(self);
            [self getWeatherInfoWithType:HMWeatherInfoTypeCurrent locationKey:key isGlobal:isGlobalUser Success:^(id weatherData) {
                @strongify(self);
                id<HMServiceAPIWeatherRealTimeData> realData = weatherData;
                HMWeatherCurrentItem *realItem = [[HMWeatherCurrentItem alloc] initWithRealTimeData:realData locationKey:key];
                NSError *error = [self.dbWeatherService addOrUpdateCurrenWeather:realItem];
                if (error) {
                    HMLogW(weather, @"fetch curWeather add or update error: %@",error);
                }
                completion(YES, realItem);
            } Fail:^(NSString *message) {
                HMLogW(weather, @"fetch cur weather error: %@",message);
                completion(NO, nil);
            }];
        }];
    } else {
        completion(YES, curWeather);
    }
}

- (void)getLocationInfoWithCityName:(NSString *)cityName
                           isGlobal:(BOOL)isGlobalUser
                         Completion:(HMWeatherCityResultBlock)cityBlock {
    [[HMServiceAPI defaultService] weather_locationDataWithCityName:cityName isGlobal:isGlobalUser completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas) {
        if (!success) {
            HMLogW(weather, @"weather_info ,get location key by city name fail: %@",message);
            cityBlock(nil, NO);
            return ;
        }
        NSMutableArray *locationItems = [NSMutableArray array];
        for (id<HMServiceAPIWeatherLocationData> locationInfo in locationDatas) {
            HMWeatherLocationItem *item = [[HMWeatherLocationItem alloc] initWithLocation:locationInfo];
            [locationItems addObject:item];
        }
        if (cityBlock) {
            cityBlock(locationItems, YES);
        }
    }];
}

- (void)requestWeatherInfoWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate
                                        isGlobal:(BOOL)isGlobalUser
                                      Completion:(HMWeatherRequestBlock)block {
    [self getCurrentLocationInfoWithCoordination:locationCoordinate isGlobal:isGlobalUser Completion:^(HMWeatherLocationItem *litem) {
        [self requestWeatherWithSepcifiedLocationKey:nil
                                        locationItem:litem
                                            isGlobal:isGlobalUser
                                          Completion:block];
    }];
}

- (void)requestWeatherInfoWithLocationKey:(NSString *)locationKey
                                 isGlobal:(BOOL)isGlobalUser
                               Completion:(HMWeatherRequestBlock)block {
    if (!locationKey.length) {
        return ;
    }
    [self requestWeatherWithSepcifiedLocationKey:locationKey
                                     locationItem:nil
                                        isGlobal:isGlobalUser
                                      Completion:block];
}

#pragma mark - location key signal

/**
 根据定位信息获取location Key相关信息

 @param locationCoordinate 定位
 @param isGlobalUser 是否是国外用户
 @param completion completion
 */
- (void)getCurrentLocationInfoWithCoordination:(CLLocationCoordinate2D)locationCoordinate
                                      isGlobal:(BOOL)isGlobalUser
                                    Completion:(void (^)(HMWeatherLocationItem *litem))completion {
    HMWeatherLocationItem *locationItem = [HMWeatherLocationItem fromStoreObj:[self.weatherUserDefaults objectForKey:userDefalutLastLocation]];
    BOOL locationKeyNeedUpdate = NO;
    if (!locationItem) {
        locationKeyNeedUpdate = YES;
    } else {
        CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:locationItem.currentLatitude longitude:locationItem.currentLongitude];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
        CLLocationDistance distances = [currentLocation distanceFromLocation:lastLocation];
        HMLogD(weather, @"weather_info ,locationItem is nil: %d, lastlocation : %@; curlocation: %@, distance: %.2fkm", (locationItem == nil),lastLocation, currentLocation, distances/1000);
        
        locationKeyNeedUpdate = ([currentLocation distanceFromLocation:lastLocation] > self.LocationMargin * 1000) ? YES : NO;
    }
    
    if (!locationKeyNeedUpdate) {
        HMLogW(weather, @"weather_info ,locationKey不需要更新");
        completion(locationItem);
        return;
    }
    [self fetchLocation:locationCoordinate
               isGlobal:isGlobalUser
                success:^(id<HMServiceAPIWeatherLocationData> locationData) {
                    // 记录定位信息
                    HMLogD(weather, @"weather_info ,locationKey已更新, 记录在locationItem信息");
                    HMWeatherLocationItem *location = [[HMWeatherLocationItem alloc] initWithLocation:locationData];
                    location.currentLongitude = locationCoordinate.longitude;
                    location.currentLatitude = locationCoordinate.latitude;
                    [self.weatherUserDefaults setObject:location.storeObj forKey:userDefalutLastLocation];
                    [self.weatherUserDefaults synchronize];
                    
                    completion(location);
                } fail:^{
                    completion(locationItem);
                }];
}

#pragma mark - weather info signal

/**
 实时天气数据

 @param key location Key
 @param isGlobalUser isGlobalUser
 @return signal signal
 */
- (RACSignal *)getCurrentDayWeatherWithLocationKey:(NSString *)key isGlobal:(BOOL)isGlobalUser{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
        [self getWeatherInfoWithType:HMWeatherInfoTypeCurrent
                         locationKey:key
                            isGlobal:isGlobalUser
                             Success:^(id weatherData) {
            @strongify(self);
            if (!weatherData) {
                HMLogW(weather, @"current weather data is null.");
            } else {
                id<HMServiceAPIWeatherRealTimeData> realTimeData = weatherData;
                HMWeatherCurrentItem *currentItem = [[HMWeatherCurrentItem alloc] initWithRealTimeData:realTimeData locationKey:key];
                NSError *error = [self.dbWeatherService addOrUpdateCurrenWeather:currentItem];
                if (error) {
                    HMLogW(weather, @"add or update CurrentWeather error: %@",error);
                }
            }
            
            [subscriber sendCompleted];
        } Fail:^(NSString *message) {
            HMLogW(weather, @"get current weather error:%@",message);
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

/**
 天气预报

 @param days 天数(注意: 返回的数据数目有时少有时多.)
 @param key locationKey
 @param isGlobalUser isGlobalUser
 @return siganl siganl
 */
- (RACSignal *)getForecastWeatherWithDays:(NSInteger)days
                          WithLocationKey:(NSString *)key
                                 isGlobal:(BOOL)isGlobalUser {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
        [self getWeatherInfoWithType:HMWeatherInfoTypeForecast locationKey:key isGlobal:isGlobalUser Success:^(id weatherData) {
            @strongify(self);
            if (!weatherData) {
                HMLogW(weather, @"forecast weather data is null.");
            } else {
                [self.dbWeatherService removeAllWeatherForecast];
                id<HMServiceAPIWeatherForecastData> forecastData = weatherData;
                NSArray<HMWeatherForecastItem *> *datas = [HMWeatherForecastItem forecastItemsWithData:forecastData locationKey:key];
                NSError *error = [self.dbWeatherService addWeatherForecasts:datas];
                if (error) {
                    HMLogW(weather, @"add forecast Weather error : %@",error);
                }
            }
            
            [subscriber sendCompleted];
        } Fail:^(NSString *message) {
            HMLogW(weather, @"get forecasts weather error:%@",message);
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

/**
 AQI数据

 @param key location Key
 @param isGlobalUser isGlobalUser
 @return siganl siganl
 */
- (RACSignal *)getAirQualityWithLocationKey:(NSString *)key isGlobal:(BOOL)isGlobalUser{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
        [self getWeatherInfoWithType:HMWeatherInfoTypeAQI locationKey:key isGlobal:isGlobalUser Success:^(id weatherData) {
            @strongify(self);
            if (!weatherData) {
                HMLogW(weather, @"airQuality weather data is null.");
            } else {
                id<HMServiceAPIWeatherAirQualityData> airQualityData = weatherData;
                HMWeatherAirQualityItem *aqiWeatherItem = [[HMWeatherAirQualityItem alloc] initWithAQIData:airQualityData locationKey:key];
                NSError *error = [self.dbWeatherService addOrUpdateAQIRecord:aqiWeatherItem];
                if (error) {
                    HMLogW(weather, @"add or update AQI error: %@",error);
                }
            }
            
            [subscriber sendCompleted];
        } Fail:^(NSString *message) {
            HMLogW(weather, @"get airQuality weather error:%@",message);
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

/**
 天气预警

 @param key location Key
 @param isGlobalUser isGlobalUser
 @return siganl siganl
 */
- (RACSignal *)getWeatherAlertWithLocationKey:(NSString *)key isGlobal:(BOOL)isGlobalUser{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @weakify(self);
        [self getWeatherInfoWithType:HMWeatherInfoTypeAlert locationKey:key isGlobal:isGlobalUser Success:^(id weatherData) {
            @strongify(self);
            id<HMServiceAPIWeatherWarningData> weatherWarningData = weatherData;
            HMWeatherAlertItem *alertItem = [[HMWeatherAlertItem alloc] initWithWarningData:weatherWarningData locationKey:key];
            NSError *error = [self.dbWeatherService addOrUpdateEarlyWarning:alertItem];
            if (error) {
                HMLogW(weather, @"add or update Alert error: %@",error);
            }
            [subscriber sendCompleted];
        } Fail:^(NSString *message) {
            HMLogW(weather, @"get weather alert error:%@",message);
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

#pragma mark - private func
- (void)requestWeatherWithSepcifiedLocationKey:(NSString *)lKey
                                  locationItem:(HMWeatherLocationItem *)lItem
                                       isGlobal:(BOOL)isGlobalUser
                                     Completion:(HMWeatherRequestBlock)block {
    if (!block || self.isRequesting) {
        return;
    }
    
    [self checkOldWeatherData];
    
    NSString *lastLocationKey = [self.weatherUserDefaults objectForKey:userDefaultLocationKey];
    
    id<HMDBWeatherAQIProtocol> currentAQI = [self.dbWeatherService currentAQIAt:lastLocationKey];
    id<HMDBCurrentWeatherProtocol> currentWeather = [self.dbWeatherService currentWeatherAt:lastLocationKey];
    id<HMDBWeatherEarlyWarningProtocol> currentWarning = [self.dbWeatherService earlyWarningAt:lastLocationKey];
    id<HMDBWeatherForecastProtocol> currentForecast = [self.dbWeatherService weatherForecastAt:lastLocationKey].lastObject;
    
    //1.1 与上次比较，行政区变化，重新获取locationKey (hefei --> 合肥)
    BOOL locationKeyChanged = NO;
    BOOL weatherDataupdate = NO;
    if (lKey && ![lKey isEqualToString:lastLocationKey]) {
        lastLocationKey = lKey;
        locationKeyChanged = YES;
        [self.weatherUserDefaults setObject:lKey forKey:userDefaultLocationKey];
        [self.weatherUserDefaults synchronize];
        HMLogW(weather, @"weather_info ,locationKey已更新(传递指定的 location key,手动选择模式)");
    } else if (!lKey) {
        HMWeatherLocationItem *locationItem = [HMWeatherLocationItem fromStoreObj:[self.weatherUserDefaults objectForKey:userDefalutLastLocation]];
        if (locationItem && ![locationItem.locationKey isEqualToString:lastLocationKey]) {
            lastLocationKey = locationItem.locationKey;
            locationKeyChanged = YES;
            [self.weatherUserDefaults setObject:locationItem.locationKey forKey:userDefaultLocationKey];
            [self.weatherUserDefaults synchronize];
            HMLogW(weather, @"weather_info ,locationKey已更新(未传递指定的 location key,自动定位模式)");
        }
    }
    
    NSMutableArray *signalArr = [NSMutableArray array];
    NSDate *curDate = [NSDate date];
    
    //2.1 预警，AQI，实时，每一个小时获取一次
    if (!currentWeather || locationKeyChanged || [currentWeather.dbRecordUpdateTime secondsBeforeDate:curDate] > self.AQIUpdateHours * 60 * 60) {
        weatherDataupdate = YES;
        [signalArr addObject:[self getCurrentDayWeatherWithLocationKey:lastLocationKey isGlobal:isGlobalUser]];
    }
    
    if (!currentAQI || locationKeyChanged || [currentAQI.dbRecordUpdateTime secondsBeforeDate:curDate] > self.AQIUpdateHours * 60 * 60) {
        weatherDataupdate = YES;
        [signalArr addObject:[self getAirQualityWithLocationKey:lastLocationKey isGlobal:isGlobalUser]];
    }
    
    BOOL needUpdateAlertData = self.needAlertPush && (!currentWarning || locationKeyChanged || [currentWarning.dbRecordUpdateTime secondsBeforeDate:curDate] > self.AQIUpdateHours * 60 * 60);
    if (needUpdateAlertData) {
        weatherDataupdate = YES;
        [signalArr addObject:[self getWeatherAlertWithLocationKey:lastLocationKey isGlobal:isGlobalUser]];
    }
    //2.2 天气预报，请求相差8小时 或者 行政区变化 重新请求.
    if (!currentForecast || locationKeyChanged || [currentForecast.dbRecordUpdateTime secondsBeforeDate:curDate] > self.RequestForecastHours * 60 * 60) {
        HMLogD(weather, @"weather_info ,天气预报数据需要更新.");
        weatherDataupdate = YES;
        [signalArr addObject:[self getForecastWeatherWithDays:self.ForecastDays
                                              WithLocationKey:lastLocationKey
                                                     isGlobal:isGlobalUser]];
    }
    // 是否正在请求.
    self.isRequesting = weatherDataupdate;
    if (signalArr.count > 0) {
        [[RACSignal combineLatest:signalArr] subscribeCompleted:^{
            self.isRequesting = NO;
            block(lastLocationKey, YES, weatherDataupdate);
        }];
    } else {
        HMLogD(weather, @"weather_info ,不需要更新任意数据.");
        block(lastLocationKey, YES, weatherDataupdate);
    }
}

- (void)fetchLocation:(CLLocationCoordinate2D)locationCoordinate
             isGlobal:(BOOL)isGlobalUser
              success:(void (^)(id<HMServiceAPIWeatherLocationData> locationData))successHandler
                 fail:(void (^)(void))failHandler {
    [[HMServiceAPI defaultService] weather_locationDataWithCoordination:locationCoordinate isGlobal:isGlobalUser completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData) {
        if (!success) {
            HMLogW(weather, @"weather_info ,location key get error: %@",message);
            failHandler();
            return ;
        }
        NSString *key = locationData.api_locationDataKey;
        if (key.length) {
            successHandler(locationData);
        }
    }];
}

- (void)getWeatherInfoWithType:(HMWeatherInfoType)weatherType
                   locationKey:(NSString *)key
                      isGlobal:(BOOL)isGlobalUser
                       Success:(void (^)(id weatherData))successHandler
                          Fail:(void (^)(NSString *message))failHandler {
    switch (weatherType) {
        case HMWeatherInfoTypeCurrent: {
            [[HMServiceAPI defaultService] weather_realTimeDataWithLocationKey:key
                                                                      isGlobal:isGlobalUser
                                                               completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherRealTimeData> realTimeData) {
                                                                   if (success) {
                                                                       successHandler(realTimeData);
                                                                   } else {
                                                                       failHandler(message);
                                                                   }
                                                               }];
        }
            break;
        case HMWeatherInfoTypeAlert: {
            [[HMServiceAPI defaultService] weather_weatherWarningDataWithLocationKey:key
                                                                            isGlobal:isGlobalUser
                                                                     completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherWarningData> weatherWarningData) {
                                                                         if (success) {
                                                                             successHandler(weatherWarningData);
                                                                         } else {
                                                                             failHandler(message);
                                                                         }
                                                                     }];
        }
            break;
        case HMWeatherInfoTypeAQI: {
            [[HMServiceAPI defaultService] weather_airQualityDataWithLocationKey:key
                                                                        isGlobal:isGlobalUser
                                                                 completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherAirQualityData> airQualityData) {
                                                                     if (success) {
                                                                         successHandler(airQualityData);
                                                                     } else {
                                                                         failHandler(message);
                                                                     }
                                                                 }];
        }
            break;
        case HMWeatherInfoTypeForecast: {
            [[HMServiceAPI defaultService] weather_forecastDataWithLocationKey:key
                                                                      isGlobal:isGlobalUser
                                                                          days:self.ForecastDays
                                                               completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherForecastData> forecastData) {
                                                                   if (success) {
                                                                       successHandler(forecastData);
                                                                   } else {
                                                                       failHandler(message);
                                                                   }
                                                               }];
        }
            break;
    }
    
}

/** 检查旧数据locationKey字段 */
- (void)checkOldWeatherData {
    BOOL didCheckVersion1To2 = [self.weatherUserDefaults boolForKey:version1_TO_2];
    if (didCheckVersion1To2) {
        return;
    }
    NSArray<id<HMDBWeatherForecastProtocol>> *forecasts = [self.dbWeatherService allWeatherForecast];
    [forecasts enumerateObjectsUsingBlock:^(id<HMDBWeatherForecastProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.dbLocationKey || [obj.dbLocationKey isEqualToString:@""]) {
            BOOL cleanStatus = [self cleanWeatherData];
            if (cleanStatus) {
                [self.weatherUserDefaults setBool:YES forKey:version1_TO_2];
                [self.weatherUserDefaults synchronize];
            } else {
                HMLogW(weather, @"清除旧weather version1_to_2 数据失败.");
            }
            *stop = YES;
        }
    }];
}

- (NSDate *)dateFromWeatherTimeStr:(NSString *)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *destDate = [dateFormatter dateFromString:time];
    
    return destDate;
}
@end
