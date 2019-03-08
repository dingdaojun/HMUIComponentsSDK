//  AZConfigurationTest.m
//  Created on 2018/3/21
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;

@interface AZConfigurationTest : HMServiceTest

@end

@implementation AZConfigurationTest

- (void)setUp {
    [super setUp];

    HMServiceAPI.defaultDelegate = self;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.


    
}

- (void)testAzConfiguration {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testAzConfiguration"];

    id<HMCancelableAPI> api = [[HMServiceAPI defaultService] azConfiguration_retrieveWithCompletionBlock:^(BOOL success, NSString *message,  id<HMServiceAPIConfiguration> configuration) {

        if (!configuration) {
            [expectation fulfill];
            return;
        }

        NSLog(@"MainDeviceID is: %@", configuration.api_azConfigurationMainDeviceID);
        NSLog(@"AllDayHeartRate is: %d", configuration.api_azConfigurationAllDayHeartRate);
        NSLog(@"StepTarget is: %d", (int)configuration.api_azConfigurationStepTarget);

        [expectation fulfill];
    }];

    [api printCURL];

    [self waitForExpectations:@[expectation] timeout:60];
}


@end
