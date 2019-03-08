//  HMDBWeatherServiceEWTest.m
//  Created on 2018/5/14
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBWeather/HMDBWeatherService.h>
#import <HMDBWeather/HMDBWeatherService+EarlyWarning.h>
#import <HMDBWeather/HMDBWeatherBaseConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBWeatherServiceEWTest : XCTestCase

@property(nonatomic, strong)HMDBWeatherService *service;

@end

@implementation HMDBWeatherServiceEWTest

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

- (void)testEWSameThread {

    id mockProtocol = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([mockProtocol dbTitle]).andReturn(@"测试标题");

    NSError *error = [_service addOrUpdateEarlyWarning:mockProtocol];
    XCTAssertNil(error);

    id updateProtocol = [self dataGenerateWithTag:@"AHHF"];
    OCMStub([updateProtocol dbTitle]).andReturn(@"更新测试标题");
    error = [_service addOrUpdateEarlyWarning:updateProtocol];
    XCTAssertNil(error);

    // 验证
    NSArray *result = [_service allEarlyWarning];
    XCTAssert(result.count == 1);

    id<HMDBWeatherEarlyWarningProtocol> protocol = [result firstObject];
    XCTAssertNotNil(protocol);
    XCTAssert([protocol.dbTitle isEqualToString:@"更新测试标题"]);

    // 查询 LocationKey
    protocol = [_service earlyWarningAt:@"AHHF1"];
    XCTAssertNil(protocol);

    protocol = [_service earlyWarningAt:@"AHHF"];
    XCTAssertNotNil(protocol);

    // 移除验证
    [_service removeEarlyWarningAt:@"AHHF"];
    protocol = [_service earlyWarningAt:@"AHHF"];
    XCTAssertNil(protocol);

    result = [_service allEarlyWarning];
    XCTAssert(result.count == 0);
}

- (id)dataGenerateWithTag:(NSString *)locationKey {
    id mockProtocol = OCMProtocolMock(@protocol(HMDBWeatherEarlyWarningProtocol));
    
    OCMStub([mockProtocol dbEarlyWarningPublishTime]).andReturn(@"");
    OCMStub([mockProtocol dbWarningID]).andReturn(@"");
    OCMStub([mockProtocol dbDetail]).andReturn(@"");
    OCMStub([mockProtocol dbRecordUpdateTime]).andReturn([NSDate date]);
    OCMStub([mockProtocol dbLocationKey]).andReturn(locationKey);
    
    return mockProtocol;
}

@end
