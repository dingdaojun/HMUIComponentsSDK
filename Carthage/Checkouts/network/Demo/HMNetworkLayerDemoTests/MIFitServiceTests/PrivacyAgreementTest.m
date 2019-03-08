//  PrivacyAgreementTest.m
//  Created on 2018/5/18
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;


@interface PrivacyAgreementTest : HMServiceTest

@end

@implementation PrivacyAgreementTest

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


- (void)testPrivacyAgreement {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testPrivacyAgreement"];

    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              privacyAgreement_retrieveWithType:@"agreement"
                              countryCode:@"DE"
                              isAuth:NO
                              completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIPrivacyAgreementVersion>> *privacyAgreements) {

                                  if (!success) {
                                      [expectation fulfill];
                                      return;
                                  }

                                  for (id<HMServiceAPIPrivacyAgreementVersion> privacyAgreement in privacyAgreements) {

                                      NSLog(@"Language %@", privacyAgreement.api_privacyAgreementLanguage);
                                      NSLog(@"Version %@", privacyAgreement.api_privacyAgreementVersion);
                                  }


                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

@end
