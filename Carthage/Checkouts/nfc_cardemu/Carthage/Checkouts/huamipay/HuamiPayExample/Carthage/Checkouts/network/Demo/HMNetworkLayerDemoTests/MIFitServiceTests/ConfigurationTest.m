//  ConfigurationTest.m
//  Created on 2018/5/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;


@interface ConfigurationTest : HMServiceTest

@end

@implementation ConfigurationTest

- (void)setUp {
    [super setUp];

    HMServiceAPI.defaultDelegate = self;
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

//- (void)testUpdateConfiguration {
//    XCTestExpectation *expectation = [self expectationWithDescription:@"testUpdateConfiguration"];
//
//    id<HMCancelableAPI> api = [[HMServiceAPI defaultService] configuration_retrieveWithCompletionBlock1:^(BOOL success, NSString *message,  NSDictionary *configuration) {
//
//        if (!configuration) {
//            [expectation fulfill];
//            return;
//        }
//
//        NSLog(@"configuration is: %@", configuration);
//        [expectation fulfill];
//    }];
//
//    [api printCURL];
//
//    [self waitForExpectations:@[expectation] timeout:60];
//}
//
//- (void)testConfiguration {
//
//    XCTestExpectation *expectation = [self expectationWithDescription:@"testConfiguration"];
//
//    id<HMCancelableAPI> api = [[HMServiceAPI defaultService] configuration_update:nil
//                                                                  completionBlock:^(BOOL success, NSString *message) {
//
//        [expectation fulfill];
//    }];
//
//    [api printCURL];
//
//    [self waitForExpectations:@[expectation] timeout:60];
//}

@end
