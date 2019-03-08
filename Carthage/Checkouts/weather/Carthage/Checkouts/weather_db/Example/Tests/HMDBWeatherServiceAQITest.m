//  HMDBWeatherServiceAQITest.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBWeather/HMDBWeatherService.h>
#import <HMDBWeather/HMDBWeatherService+AQI.h>
#import <HMDBWeather/HMDBWeatherBaseConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBWeatherServiceAQITest : XCTestCase

@property(nonatomic, strong)HMDBWeatherService *service;

@end

@implementation HMDBWeatherServiceAQITest

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

- (void)testAQISameThread {

    id mockProtocol = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([mockProtocol dbValueOfAQI]).andReturn(50);

    NSError *error = [_service addOrUpdateAQIRecord:mockProtocol];
    XCTAssertNil(error);

    id mockUpdateProtocol = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([mockUpdateProtocol dbValueOfAQI]).andReturn(60);
    error = [_service addOrUpdateAQIRecord:mockUpdateProtocol];
    XCTAssertNil(error);

    // 验证
    NSArray *result = [_service allAQI];
    XCTAssert(result.count == 1);

    id<HMDBWeatherAQIProtocol> protocol = [result firstObject];
    XCTAssertNotNil(protocol);
    XCTAssert(protocol.dbValueOfAQI == 60);

    // 查询 LocationKey
    protocol = [_service currentAQIAt:@"AHHF1"];
    XCTAssertNil(protocol);

    protocol = [_service currentAQIAt:@"AHHF"];
    XCTAssertNotNil(protocol);

    // 移除验证
    [_service removeAQIAt:@"AHHF"];
    protocol = [_service currentAQIAt:@"AHHF"];
    XCTAssertNil(protocol);

    result = [_service allAQI];
    XCTAssert(result.count == 0);
}

- (id)dataGenerateWithTag:(NSString *)locationKey {
    id mockProtocol = OCMProtocolMock(@protocol(HMDBWeatherAQIProtocol));
    
    OCMStub([mockProtocol dbWeatherAQIPublishTime]).andReturn(@"");
    OCMStub([mockProtocol dbRecordUpdateTime]).andReturn([NSDate date]);
    OCMStub([mockProtocol dbLocationKey]).andReturn(locationKey);
    
    return mockProtocol;
}

@end
