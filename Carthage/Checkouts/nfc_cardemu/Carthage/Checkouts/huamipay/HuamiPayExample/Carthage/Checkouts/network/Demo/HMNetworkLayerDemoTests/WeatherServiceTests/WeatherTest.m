//  WeatherTest.m
//  Created on 2018/3/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import WeatherService;
@import OCMock;


@interface WeatherTest : HMServiceTest

@end

@implementation WeatherTest

- (void)setUp {
    [super setUp];
    HMServiceAPI.defaultDelegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testLocationData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testLocationData"];

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(31.84116554260254, 117.1313934326172);
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_locationDataWithCoordination:coordinate
                                                                      isGlobal:NO
                                                               completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherLocationData> locationData) {

                                                                   [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                          parameters:nil
                                                                                             success:success
                                                                                             message:message
                                                                                                data:locationData];
                                                                   if (!locationData) {
                                                                       [expectation fulfill];
                                                                       return;
                                                                   }

                                                                   NSLog(@"locationData");
                                                                   NSLog(@"Name %@", locationData.api_locationDataName);
                                                                   NSLog(@"Affiliation %@", locationData.api_locationDataAffiliation);
                                                                   NSLog(@"Key %@", locationData.api_locationDataKey);
                                                                   NSLog(@"Coordinate  latitude %f", locationData.api_locationDataCoordinate.latitude);
                                                                   NSLog(@"Coordinate  longitude %f", locationData.api_locationDataCoordinate.longitude);
                                                                   NSLog(@"Status %d", locationData.api_locationDataStatus);
                                                                   [expectation fulfill];
                                                               }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testCityData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testCityData"];

    NSString *cityName = @"Nueva York";
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_locationDataWithCityName:cityName
                                                                  isGlobal:YES
                                                           completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIWeatherLocationData>> *locationDatas) {

                                                               [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                      parameters:nil
                                                                                         success:success
                                                                                         message:message
                                                                                            data:locationDatas];

                                                               if (locationDatas.count == 0) {
                                                                   [expectation fulfill];

                                                                   return;
                                                               }

                                                               for (id<HMServiceAPIWeatherLocationData> locationData in locationDatas) {
                                                                   NSLog(@"locationData");
                                                                   NSLog(@"Name %@", locationData.api_locationDataName);
                                                                   NSLog(@"Affiliation %@", locationData.api_locationDataAffiliation);
                                                                   NSLog(@"Key %@", locationData.api_locationDataKey);
                                                                   NSLog(@"Coordinate  latitude %f", locationData.api_locationDataCoordinate.latitude);
                                                                   NSLog(@"Coordinate  longitude %f", locationData.api_locationDataCoordinate.longitude);
                                                                   NSLog(@"Status %d", locationData.api_locationDataStatus);
                                                                   NSLog(@"");
                                                               }
                                                               [expectation fulfill];
                                                           }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testRealTimeData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testRealTimeData"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_realTimeDataWithLocationKey:@"weathercn:101220104"
                                                                     isGlobal:NO
                                                              completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherRealTimeData> realTimeData) {

                                                                  NSLog(@"Visibility Value %@", realTimeData.api_realTimeDataVisibility.api_realTimeDataValue);
                                                                  NSLog(@"Visibility Unit %@", realTimeData.api_realTimeDataVisibility.api_realTimeDataUnit);

                                                                  NSLog(@"Humidity Value %@", realTimeData.api_realTimeDataHumidity.api_realTimeDataValue);
                                                                  NSLog(@"Humidity Unit %@", realTimeData.api_realTimeDataHumidity.api_realTimeDataUnit);

                                                                  NSLog(@"WindSpeed Value %@", realTimeData.api_realTimeDataWindSpeed.api_realTimeDataValue);
                                                                  NSLog(@"WindSpeed Unit %@", realTimeData.api_realTimeDataWindSpeed.api_realTimeDataUnit);

                                                                  NSLog(@"WindDirection Value %@", realTimeData.api_realTimeDataWindDirection.api_realTimeDataValue);
                                                                  NSLog(@"WindDirection Unit %@", realTimeData.api_realTimeDataWindDirection.api_realTimeDataUnit);

                                                                  NSLog(@"FeelsLike Value %@", realTimeData.api_realTimeDataFeelsLike.api_realTimeDataValue);
                                                                  NSLog(@"FeelsLike Unit %@", realTimeData.api_realTimeDataFeelsLike.api_realTimeDataUnit);

                                                                  NSLog(@"Pressure Value %@", realTimeData.api_realTimeDataPressure.api_realTimeDataValue);
                                                                  NSLog(@"Pressure Unit %@", realTimeData.api_realTimeDataPressure.api_realTimeDataUnit);

                                                                  NSLog(@"Temperature Value %@", realTimeData.api_realTimeDataTemperature.api_realTimeDataValue);
                                                                  NSLog(@"Temperature Unit %@", realTimeData.api_realTimeDataTemperature.api_realTimeDataUnit);

                                                                  NSLog(@"Weather %ld", realTimeData.api_realTimeDataWeather);
                                                                  NSLog(@"UVIndex  %ld", realTimeData.api_realTimeDataUVIndex);
                                                                  //                                                                                     NSLog(@"PubTime  %@", realTimeData.api_realTimeDataPubTime);

                                                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                         parameters:nil
                                                                                            success:success
                                                                                            message:message
                                                                                               data:realTimeData];
                                                                  [expectation fulfill];
                                                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}



- (void)testForecastData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testForecastData"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_forecastDataWithLocationKey:@"weathercn:101220104"
                                                                     isGlobal:NO
                                                                         days:7
                                                              completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherForecastData> forecastData) {

                                                                  NSArray<id<HMServiceAPIWeatherForecastSunRiseSetProtocol>> *sunRiseSets =  forecastData.api_forecastDataSunRiseSet;

                                                                  for (id<HMServiceAPIWeatherForecastSunRiseSetProtocol> sunRiseSet in sunRiseSets) {
                                                                      NSLog(@"SunsetDat %@", sunRiseSet.api_forecastSunsetDate);
                                                                      NSLog(@"SunriseDate %@", sunRiseSet.api_forecastSunriseDate);
                                                                  }

                                                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                         parameters:nil
                                                                                            success:success
                                                                                            message:message
                                                                                               data:forecastData];
                                                                  [expectation fulfill];
                                                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


- (void)testAirQualityData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testAirQualityData"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_airQualityDataWithLocationKey:@"weathercn:101220104"
                                                                       isGlobal:NO
                                                                completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherAirQualityData> airQualityData) {

                                                                    [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                           parameters:nil
                                                                                              success:success
                                                                                              message:message
                                                                                                 data:airQualityData];

                                                                    if (!airQualityData) {
                                                                        [expectation fulfill];
                                                                        return;
                                                                    }

                                                                    NSLog(@"PubTime %@", airQualityData.api_airQualityDataPubTime);
                                                                    NSLog(@"AQI %ld", airQualityData.api_airQualityDataAQI);
                                                                    NSLog(@"CO %f", airQualityData.api_airQualityDataCO);
                                                                    NSLog(@"NO2 %ld", airQualityData.api_airQualityDataNO2);
                                                                    NSLog(@"O3 %ld", airQualityData.api_airQualityDataO3);
                                                                    NSLog(@"PM10 %ld", airQualityData.api_airQualityDataPM10);
                                                                    NSLog(@"PM25 %ld", airQualityData.api_airQualityDataPM25);
                                                                    NSLog(@"SO2 %ld", airQualityData.api_airQualityDataSO2);
                                                                    NSLog(@"Primary %@", airQualityData.api_airQualityDataPrimary);
                                                                    NSLog(@"Source %@", airQualityData.api_airQualityDataSource);
                                                                    [expectation fulfill];
                                                                }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testWeatherWarningData {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testWeatherWarningData"];

    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI> api = [serviceAPI weather_weatherWarningDataWithLocationKey:@"weathercn:101220104"
                                                                           isGlobal:NO
                                                                    completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIWeatherWarningData> weatherWarningData) {

                                                                        [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                                               parameters:nil
                                                                                                  success:success
                                                                                                  message:message
                                                                                                     data:weatherWarningData];

                                                                        if (!weatherWarningData) {
                                                                            [expectation fulfill];
                                                                            return;
                                                                        }

                                                                        NSLog(@"PubTime %@", weatherWarningData.api_weatherWarningDataPubTime);
                                                                        NSLog(@"AlertID %@", weatherWarningData.api_weatherWarningDataAlertID);
                                                                        NSLog(@"Title %@", weatherWarningData.api_weatherWarningDataTitle);
                                                                        NSLog(@"Type %@", weatherWarningData.api_weatherWarningDataType);
                                                                        NSLog(@"Level %@", weatherWarningData.api_weatherWarningDataLevel);
                                                                        NSLog(@"Detail %@", weatherWarningData.api_weatherWarningDataDetail);
                                                                        NSLog(@"Images %@", weatherWarningData.api_weatherWarningDataImages);

                                                                        [expectation fulfill];
                                                                    }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}



@end
