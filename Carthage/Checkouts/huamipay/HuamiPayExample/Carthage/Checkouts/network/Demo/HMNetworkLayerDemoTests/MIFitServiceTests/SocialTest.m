//  SocialTest.m
//  Created on 2018/7/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;
@import OCMock;

@interface SocialTest : HMServiceTest

@end

@implementation SocialTest

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


- (void)testSocialShare {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testSocialShare"];
    HMServiceAPI *serviceAPI = [HMServiceAPI defaultService];
    id<HMCancelableAPI>api = [serviceAPI social_shareWithAvatar:@""
                                                       nickName:@"你好"
                                                completionBlock:^(BOOL success, NSString *message,  NSString *shareUrl) {

                                                    if (shareUrl) {

                                                        NSLog(@" shareUrl %@", shareUrl);
                                                    }

                                                    [expectation fulfill];
                                                }];

    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

@end
