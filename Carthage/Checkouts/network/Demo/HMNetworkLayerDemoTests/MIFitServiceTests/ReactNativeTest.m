//  ReactNativeTest.m
//  Created on 2018/6/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;

@interface ReactNativeTest : HMServiceTest

@end

@implementation ReactNativeTest

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


- (void)testReactNativeAuthorize{

    NSString *appKey = @"10100301";
    NSString *timestamp = @"1475251200";
    NSString *nonce = @"abd23451dd";
    NSString *signature = @"1345";
    NSString *webURL = @"https://cdn.awsbj0.fds.api.mi-img.com/aos-common/bridgeTools/index.html?v=1.2";
    NSArray *apiNames = @[@"getUserToken", @"getUserToken"];

    XCTestExpectation *expectation = [self expectationWithDescription:@"testReactNativeAuthorize"];

    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              reactNative_authorizeForJavaScriptWithAppKey:appKey
                              timestamp:timestamp
                              nonce:nonce
                              signature:signature
                              webURL:webURL
                              apiNames:apiNames
                              completionBlock:^(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames) {

                                  NSDictionary *parameters = @{@"appKey" : appKey,
                                                               @"timestamp" : timestamp,
                                                               @"nonce" : nonce,
                                                               @"signature" : signature,
                                                               @"webURL" : webURL,
                                                               @"apiNames" : apiNames};

                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                         parameters:parameters
                                                            success:success
                                                            message:message
                                                               data:authorizedAPINames];
                                  [expectation fulfill];
                              }];;
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];

}

- (void)testReactNativeUpdate {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testReactNativeUpdate"];

    id<HMCancelableAPI>api = [[HMServiceAPI defaultService]
                              reactNative_updateWithModules:@[@"discovery"]
                              versions:@[@"100"]
                              completionBlock:^(BOOL success, NSString *message,id<HMServiceAPIReactNativeFileInfo> fileInfo) {

                                  [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                                         parameters:nil
                                                            success:success
                                                            message:message
                                                               data:fileInfo];
                                  if (fileInfo) {
                                      NSLog(@" Mode %@", fileInfo.api_reactNativeFileMode);
                                      NSLog(@" Key %@", fileInfo.api_reactNativeFileKey);
                                      NSLog(@" FileSize %lld", fileInfo.api_reactNativeFileSize);
                                      NSLog(@" FileUr %@", fileInfo.api_reactNativeFileUrl);
                                      NSLog(@" Version %zd", fileInfo.api_reactNativeFileVersion);
                                  }
                                  [expectation fulfill];
                              }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];

}

@end
