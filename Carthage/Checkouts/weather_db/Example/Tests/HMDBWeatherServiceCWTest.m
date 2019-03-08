//  HMDBWeatherServiceCWTest.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBWeather/HMDBWeatherService.h>
#import <HMDBWeather/HMDBWeatherService+Current.h>
#import <HMDBWeather/HMDBWeatherBaseConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBWeatherServiceCWTest : XCTestCase

@property(nonatomic, strong)HMDBWeatherService *service;

@end

@implementation HMDBWeatherServiceCWTest

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

- (void)testCWSameThread {

    id procotolMock = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([procotolMock dbTemperature]).andReturn(20);
    NSError *error = [_service addOrUpdateCurrenWeather:procotolMock];
    XCTAssertNil(error);
    
    id procotolUpdateMock = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([procotolUpdateMock dbTemperature]).andReturn(32);
    error = [_service addOrUpdateCurrenWeather:procotolUpdateMock];
    XCTAssertNil(error);

    // 验证
    NSArray *result = [_service allCurrentWeather];
    XCTAssert(result.count == 1);

    id<HMDBCurrentWeatherProtocol> protocol = [result firstObject];
    XCTAssertNotNil(protocol);
    XCTAssert(protocol.dbTemperature == 32);

    // 查询 LocationKey
    protocol = [_service currentWeatherAt:@"AHHF1"];
    XCTAssertNil(protocol);

    protocol = [_service currentWeatherAt:@"AHHF"];
    XCTAssertNotNil(protocol);

    // 移除验证
    [_service removeCurrrentAt:@"AHHF"];
    protocol = [_service currentWeatherAt:@"AHHF"];
    XCTAssertNil(protocol);

    result = [_service allCurrentWeather];
    XCTAssert(result.count == 0);
}

- (id)dataGenerateWithTag:(NSString *)locationKey {
    id mockProtocol = OCMProtocolMock(@protocol(HMDBCurrentWeatherProtocol));
    
    OCMStub([mockProtocol dbWeatherPublishTime]).andReturn(@"");
    OCMStub([mockProtocol dbWeatherType]).andReturn(0);
    OCMStub([mockProtocol dbTemperatureUnit]).andReturn(@"");
    OCMStub([mockProtocol dbRecordUpdateTime]).andReturn([NSDate date]);
    OCMStub([mockProtocol dbLocationKey]).andReturn(locationKey);
 
    
    return mockProtocol;
}

@end
