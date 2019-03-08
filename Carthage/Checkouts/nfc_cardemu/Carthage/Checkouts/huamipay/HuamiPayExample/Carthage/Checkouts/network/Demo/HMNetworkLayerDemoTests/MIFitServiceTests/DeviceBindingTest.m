//  DeviceBindingTest.m
//  Created on 2018/7/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;
@import OCMock;

@interface DeviceBindingTest : HMServiceTest

@end

@implementation DeviceBindingTest

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


- (void)testQueryBindableDevice {

    id<HMServiceAPIDeviceBindingDevice> deviceMock = OCMProtocolMock(@protocol(HMServiceAPIDeviceBindingDevice));
    OCMStub([deviceMock api_deviceBindingDeviceType]).andReturn(HMServiceAPIDeviceTypeBand);
    OCMStub([deviceMock api_deviceBindingDeviceSource]).andReturn(HMServiceAPIDeviceSourceWuhan);
    OCMStub([deviceMock api_deviceBindingDeviceMAC]).andReturn(@"E7F47537E5B6");

    XCTestExpectation *expectation = [self expectationWithDescription:@"testQueryBindableDevice"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI deviceBinding_queryBindableWithDevice:deviceMock
                                                               completionBlock:^(BOOL success, NSString *message, id<HMServiceAPIDeviceBindingInfo> info) {

                                                                   if (info) {

                                                                       NSLog(@" State %zd", info.api_deviceBindingDeviceState);
                                                                       NSLog(@" OtherUserID %@", info.api_deviceBindingDeviceOtherUserID);
                                                                       NSLog(@" OtherBingTime %@", info.api_deviceBindingDeviceOtherBingTime);
                                                                       NSLog(@" OtherNickName %@", info.api_deviceBindingDeviceOtherNickName);
                                                                   }

                                                                   [expectation fulfill];
                                                               }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}


@end
