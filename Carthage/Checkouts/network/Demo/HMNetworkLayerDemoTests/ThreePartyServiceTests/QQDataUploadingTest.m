//  QQDataUploadingTest.m
//  Created on 2018/4/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import ThreePartyService;
@import OCMock;
@import HMCategory;

@interface QQDataUploadingTest : HMServiceTest

@end

@implementation QQDataUploadingTest

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

- (void)testUploadingSleep {

    NSMutableArray *sleepDetailMocks = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        id<HMServiceAPIQQDataUploadingSleepDetailProtocol> sleepDetailMock = OCMProtocolMock(@protocol(HMServiceAPIQQDataUploadingSleepDetailProtocol));
        OCMStub([sleepDetailMock api_qqDataUploadingSleepDetailDate]).andReturn([NSDate date]);
        OCMStub([sleepDetailMock api_qqDataUploadingSleepDetailType]).andReturn(1);
        [sleepDetailMocks addObject:sleepDetailMock];
    }

    NSDate *date = [[NSDate date] startOfDay];
    NSTimeInterval time = [date timeIntervalSince1970] + 5;
    time -= 1 * 60 * 60 + (60 - 16) * 60;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    time = [date timeIntervalSince1970] + 5;
    time += 7 * 60 * 60 + 36 * 60;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:time] ;

    id<HMServiceAPIQQDataUploadingSleepProtocol> sleepMock = OCMProtocolMock(@protocol(HMServiceAPIQQDataUploadingSleepProtocol));
    OCMStub([sleepMock api_qqDataUploadingSleepStartDate]).andReturn(startDate);
    OCMStub([sleepMock api_qqDataUploadingSleepEndDate]).andReturn(endDate);
    OCMStub([sleepMock api_qqDataUploadingSleepTotalTime]).andReturn(1523144160 - 1523110560);
    OCMStub([sleepMock api_qqDataUploadingSleepLightsTime]).andReturn(485 * 60);
    OCMStub([sleepMock api_qqDataUploadingSleepDeepTime]).andReturn(75 * 60);
    OCMStub([sleepMock api_qqDataUploadingSleepAwakeTime]).andReturn(79 * 60);
    OCMStub([sleepMock api_qqDataUploadingSleepDetails]).andReturn(nil);

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadingSleep"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI QQDataUploading_sleep:sleepMock
                                                 authorization:[self getAuthorizationMock]
                                               completionBlock:^(BOOL success, NSString *message) {

                                                   [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                          parameters:nil
                                                                             success:success
                                                                             message:message
                                                                                data:nil];
                                                   [expectation fulfill];
                                               }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUploadingStep {

    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = [[[NSDate date] startOfDay] timeIntervalSince1970];
    NSInteger step = (time - startTime) / 4;
    id<HMServiceAPIQQDataUploadingStepProtocol> stepMock = OCMProtocolMock(@protocol(HMServiceAPIQQDataUploadingStepProtocol));
    OCMStub([stepMock api_qqDataUploadingStepDate]).andReturn([NSDate date]);
    OCMStub([stepMock api_qqDataUploadingStepDistance]).andReturn(0);
    OCMStub([stepMock api_qqDataUploadingStep]).andReturn(step);
    OCMStub([stepMock api_qqDataUploadingStepDuration]).andReturn(0);
    OCMStub([stepMock api_qqDataUploadingStepCalories]).andReturn(0);

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadingStep"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI QQDataUploading_step:stepMock
                                                authorization:[self getAuthorizationMock]
                                              completionBlock:^(BOOL success, NSString *message) {

                                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                         parameters:nil
                                                                            success:success
                                                                            message:message
                                                                               data:nil];
                                                  [expectation fulfill];
                                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testUploadingWeight {

    id<HMServiceAPIQQDataUploadingWeightProtocol> weightMock = OCMProtocolMock(@protocol(HMServiceAPIQQDataUploadingWeightProtocol));
    OCMStub([weightMock api_qqDataUploadingWeightDate]).andReturn([NSDate date]);
    OCMStub([weightMock api_qqDataUploadingWeight]).andReturn(78.6);
    OCMStub([weightMock api_qqDataUploadingWeightBMI]).andReturn(24.5);

    XCTestExpectation *expectation = [self expectationWithDescription:@"testUploadingWeight"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI QQDataUploading_weight:weightMock
                                                  authorization:[self getAuthorizationMock]
                                                completionBlock:^(BOOL success, NSString *message) {

                                                    [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                                           parameters:nil
                                                                              success:success
                                                                              message:message
                                                                                 data:nil];
                                                    [expectation fulfill];
                                                }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (id<HMServiceAPIQQDataUploadingAuthorizationProtocol>)getAuthorizationMock {

    id<HMServiceAPIQQDataUploadingAuthorizationProtocol> authorizationMock = OCMProtocolMock(@protocol(HMServiceAPIQQDataUploadingAuthorizationProtocol));
    OCMStub([authorizationMock api_qqDataUploadingAuthorizationToken]).andReturn(@"3EF37FBBD2459E43B87C8750E7E77138");
    OCMStub([authorizationMock api_qqDataUploadingAuthorizationAppID]).andReturn(@"1103177325");
    OCMStub([authorizationMock api_qqDataUploadingAuthorizationOpenID]).andReturn(@"0D07377C26CDB0A060814F7EC0D3683F");

    return authorizationMock;
}

@end
