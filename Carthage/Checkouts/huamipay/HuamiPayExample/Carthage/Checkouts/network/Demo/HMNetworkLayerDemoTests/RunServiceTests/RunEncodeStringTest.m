//  RunEncodeStringTest.m
//  Created on 2018/4/16
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <XCTest/XCTest.h>
@import RunService;
@import OCMock;

@interface RunEncodeStringTest : XCTestCase

@end

@implementation RunEncodeStringTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testEncodeGPS {

    NSTimeInterval startTime = 1523864434.8645349 - 1000;

    NSMutableArray *gpsMocks = [NSMutableArray array];

    for (NSInteger i; i < 10; i++) {

        CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(31.0 + i, 32 + i);

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime + i];
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate2D
                                                             altitude:100.0 + i
                                                   horizontalAccuracy:i
                                                     verticalAccuracy:i
                                                            timestamp:date];

        id<HMServiceAPIRunGPSData> gpsMock = OCMProtocolMock(@protocol(HMServiceAPIRunGPSData));
        OCMStub([gpsMock api_runGPSDataLoction]).andReturn(location);
        OCMStub([gpsMock api_runGPSFlag]).andReturn(10);
        OCMStub([gpsMock api_runGPSAltitude]).andReturn(690.0);
        OCMStub([gpsMock api_runGPSPace]).andReturn(29.0);
        OCMStub([gpsMock api_runGPSRunTime]).andReturn(60.0);
        [gpsMocks addObject:gpsMock];
    }

    NSString *encodingCoordinate2D = [gpsMocks hm_stringByEncodingLongitudeAndLatitude];
    XCTAssertTrue([encodingCoordinate2D isEqualToString:@"3100000000,3200000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;100000000,100000000;"]);

    NSString *encodingAccuracy = [gpsMocks hm_stringByEncodingAccuracy];
    XCTAssertTrue([encodingAccuracy isEqualToString:@"0;1;2;3;4;5;6;7;8;9;"]);

    NSString *encodingAltitude = [gpsMocks hm_stringByEncodingAltitude];
    XCTAssertTrue([encodingAltitude isEqualToString:@"10000;10100;10200;10300;10400;10500;10600;10700;10800;10900;"]);

    NSString *encodingTime = [gpsMocks hm_stringByEncodingTimeWithStartTime:startTime];
    XCTAssertTrue([encodingTime isEqualToString:@"0;1;1;1;1;1;1;1;1;1;"]);
}

- (void)testEncodePace {

    NSMutableArray *paceMocks = [NSMutableArray array];

    CLLocationCoordinate2D coordinate2D = CLLocationCoordinate2DMake(0, 0);

    id<HMServiceAPIRunPaceData> paceMock = OCMProtocolMock(@protocol(HMServiceAPIRunPaceData));
    OCMStub([paceMock api_runPaceKilometer]).andReturn(0);
    OCMStub([paceMock api_runPaceTime]).andReturn(92);
    OCMStub([paceMock api_runPaceTotalTime]).andReturn(92);
    OCMStub([paceMock api_runPaceLocation]).andReturn(coordinate2D);
    OCMStub([paceMock api_runPaceHeartRate]).andReturn(100);
    [paceMocks addObject:paceMock];

    paceMock = OCMProtocolMock(@protocol(HMServiceAPIRunPaceData));
    OCMStub([paceMock api_runPaceKilometer]).andReturn(1);
    OCMStub([paceMock api_runPaceTime]).andReturn(102);
    OCMStub([paceMock api_runPaceTotalTime]).andReturn(194);
    OCMStub([paceMock api_runPaceLocation]).andReturn(coordinate2D);
    OCMStub([paceMock api_runPaceHeartRate]).andReturn(100);
    [paceMocks addObject:paceMock];


    NSString *encodingPace = [paceMocks hm_stringByEncodingKiloPace];
    XCTAssertTrue([encodingPace isEqualToString:@"0,92,s000000000,-1,100,92;1,102,s000000000,-1,100,194;"]);
}

- (void)testEncodeGait {

    NSMutableArray *gaitMocks = [NSMutableArray array];
    NSTimeInterval startTime = 1523864434.8645349 - 1000;
    for (NSInteger i = 0; i < 100; i++) {

        id<HMServiceAPIRunGaitData> gaitMock = OCMProtocolMock(@protocol(HMServiceAPIRunGaitData));
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime + i];

        OCMStub([gaitMock api_runGaitStep]).andReturn(100 + i);
        OCMStub([gaitMock api_runGaitDate]).andReturn(date);
        OCMStub([gaitMock api_runGaitStepLength]).andReturn(100);
        OCMStub([gaitMock api_runGaitStepCadence]).andReturn(32.0);
        [gaitMocks addObject:gaitMock];
    }

    NSString *encodingGait = [gaitMocks hm_stringByEncodingGaitWithStartTime:startTime];
    XCTAssertTrue([encodingGait isEqualToString:@"0,100,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;1,1,100,32;"]);
}

@end



//@interface NSArray (HMServiceAPIRunDetailEncode)
//
///**
// *  @brief  步态编码
// */
//- (NSString *)hm_stringByEncodingGaitWithStartTime:(NSTimeInterval)startTime;
//
///**
// *  @brief  配速编码
// */
//- (NSString *)hm_stringByEncodingPace;
//
///**
// *  @brief  暂停编码
// */
//- (NSString *)hm_stringByEncodingPause;
//
///**
// *  @brief  gps状态编码
// */
//- (NSString *)hm_stringByEncodingFlag;
//
///**
// *  @brief  距离编码
// */
//- (NSString *)hm_stringByEncodingDistanceWithStartTime:(NSTimeInterval)startTime;
//
///**
// *  @brief  心率编码
// */
//- (NSString *)hm_stringByEncodingHeartRateWithStartTime:(NSTimeInterval)startTime;
//
///**
// *  @brief  公里编码
// */
//- (NSString *)hm_stringByEncodingKiloPace;
//
///**
// *  @brief  英里编码
// */
//- (NSString *)hm_stringByEncodingMilePace;
//
///**
// *  @brief  气压计编码
// */
//- (NSString *)hm_stringByEncodingBarometerPressureWithStartTime:(NSTimeInterval)startTime;
//
///**
// *  @brief  速度编码
// */
//- (NSString *)hm_stringByEncodingSpeedWithStartTime:(NSTimeInterval)startTime;
//
//
//@end

