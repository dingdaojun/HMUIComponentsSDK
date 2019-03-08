//  HMDBWeatherServiceFCTest.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBWeather/HMDBWeatherService.h>
#import <HMDBWeather/HMDBWeatherService+Forecast.h>
#import <HMDBWeather/HMDBWeatherBaseConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBWeatherServiceFCTest : XCTestCase

@property(nonatomic, strong)HMDBWeatherService *service;

@end

@implementation HMDBWeatherServiceFCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [HMDBWeatherBaseConfig configUserID:@"1000"];
    _service = [[HMDBWeatherService alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [HMDBWeatherBaseConfig clearDatabase];
}

- (void)testFCSameThread {
    NSArray *result = [_service allWeatherForecast];
    XCTAssert(result.count == 0);

    result = [self generateGroupFC:@"AHHF"];
    NSError *error = [_service addWeatherForecasts:result];
    XCTAssertNil(error);

    // 查询
    result = [_service weatherForecastAt:@"AHHF1"];
    XCTAssert(result.count == 0);

    result = [_service weatherForecastAt:@"AHHF"];
    XCTAssert(result.count == 7);

    NSDate *now = [NSDate date];

    result = [_service lastNWeatherForecast:2 beforeAt:now withLocation:@"AHHF"];
    XCTAssert(result.count == 1);

    result = [_service lastNWeatherForecast:4 afterAt:now withLocation:@"AHHF"];
    XCTAssert(result.count == 4);

    // 删除
    error = [_service deleteNWeatherForecast:2 beforeAt:now withLocation:@"AHHF"];
    XCTAssertNil(error);

    error = [_service deleteNWeatherForecast:4 afterAt:now withLocation:@"AHHF"];
    XCTAssertNil(error);

    result = [_service weatherForecastAt:@"AHHF"];
    XCTAssert(result.count == 2);

    [_service deleteWeatherForecastAt:@"AHHF"];
    result = [_service weatherForecastAt:@"AHHF"];
    XCTAssert(result.count == 0);
}


- (NSArray<id<HMDBWeatherForecastProtocol> > *)generateGroupFC:(NSString *)location {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:7];

    for (NSInteger index = 0 ; index < 7; index++) {
        id protocol = [self dataGenerateWithTag:location index:index];
        [arr addObject:protocol];
    }

    return arr;
}
//
- (id)dataGenerateWithTag:(NSString *)locationKey index:(NSInteger)index{
    id mockProtocol = OCMProtocolMock(@protocol(HMDBWeatherForecastProtocol));
    
    NSTimeInterval timeInterval = 1440 * 60 * index;
    
    OCMStub([mockProtocol dbForecastPublishTime]).andReturn(@"");
    OCMStub([mockProtocol dbWeatherFromValue]).andReturn(0);
    OCMStub([mockProtocol dbWeatherToValue]).andReturn(0);
    OCMStub([mockProtocol dbTemperatureFromValue]).andReturn(0);
    OCMStub([mockProtocol dbTemperatureToValue]).andReturn(0);
    OCMStub([mockProtocol dbTemperatureUnit]).andReturn(@"");
    OCMStub([mockProtocol dbRecordUpdateTime]).andReturn([[NSDate date] dateByAddingTimeInterval:timeInterval]);
    OCMStub([mockProtocol dbForecastDateTime]).andReturn([[NSDate date] dateByAddingTimeInterval:timeInterval]);
    OCMStub([mockProtocol dbSunriseDateString]).andReturn(@"");
    OCMStub([mockProtocol dbSunsetDateString]).andReturn(@"");
    OCMStub([mockProtocol dbLocationKey]).andReturn(locationKey);
  
    return mockProtocol;
}
@end
