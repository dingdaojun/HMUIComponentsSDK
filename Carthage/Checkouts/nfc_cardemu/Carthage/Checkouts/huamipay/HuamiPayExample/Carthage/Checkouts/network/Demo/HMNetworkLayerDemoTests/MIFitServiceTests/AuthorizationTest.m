//  AuthorizationTest.m
//  Created on 2018/5/22
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;

@interface AuthorizationTest : HMServiceTest

@end

@implementation AuthorizationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

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

- (void)testMinorAuthorizatio {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testMinorAuthorizatio"];

    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              authorization_retrieveWithCompletionBlock:^(BOOL success, NSString *message, id<HMServiceAPIMinorAuthorization> minorAuthorization) {

                                  if (!success) {
                                      [expectation fulfill];
                                      return;
                                  }

                                  if (minorAuthorization) {
                                      NSLog(@"Authorization %d", minorAuthorization.api_minorAuthorization);
                                      NSLog(@"day %d", (int)minorAuthorization.api_minorAuthorizationDay);
                                  }

                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
    
}

//curl -i \
//-H "v:2.0"  \
//-H "hm-privacy-ceip:true"  \
//-H "channel:appstore"  \
//-H "apptoken:cQVBQFJyQktGHlp6QkpbRl5LRl5qek4uXAQABAAAAAJsv4F5z5ASHPPUlHiXN7BmioiIw94mrTt1VFDd2-N58U4wU3uhw5vFPnRq1i5ub7LkRmQ8cqo6R_1cq6xgJFSuBojc_sB5mF2PTt9ZgBQ-ZnK1o9HE_wVS07qNfKVVN-k4rEYrNpd7i-JpWAP-rPq1Q8rvN-HxFxVwlWIUxfwSw"  \
//-H "appname:com.xiaomi.hm.health"  \
//-H "Accept-Language:zh-Hans-DE;q=1, en-DE;q=0.9, zh-Hant-DE;q=0.8"  \
//-H "X-Request-Id:5D33C327-CBC9-422C-BBC8-8D042F05F16A"  \
//-H "cv:82_3.3.2"  \
//-H "lang:zh_CN"  \
//-H "timezone:Asia/Shanghai"  \
//-H "appplatform:ios_phone"  \
//-H "User-Agent:MiFit/3.3.2 (iPhone; iOS 11.3; Scale/3.00)"  \
//-H "hm-privacy-diagnostics:false"  \
//-H "country:CN"  \
//"https://api-mifit-staging.huami.com/discovery/mi/discovery/sleep_ad?r=94396B01-CF16-4AA9-A266-BC9D436ABE4A&t=1529573584908&userid=1000152796"

@end
