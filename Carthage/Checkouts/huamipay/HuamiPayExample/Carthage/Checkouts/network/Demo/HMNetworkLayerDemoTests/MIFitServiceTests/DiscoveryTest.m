//  DiscoveryTest.m
//  Created on 2018/3/26
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceTest.h"
@import MIFitService;
@import OCMock;

@interface DiscoveryTest : HMServiceTest

@end

@implementation DiscoveryTest

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


- (void)testDismissDot {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testDismissDot"];

    id<HMServiceAPIDiscoveryDotDismissData> mock1 = OCMProtocolMock(@protocol(HMServiceAPIDiscoveryDotDismissData));
    OCMStub([mock1 api_discoveryDotDismissTime]).andReturn([NSDate date]);
    OCMStub([mock1 api_discoveryDotModule]).andReturn(HMServiceAPIModuleTempoWatchSkin);
    id<HMServiceAPIDiscoveryDotDismissData> mock2 = OCMProtocolMock(@protocol(HMServiceAPIDiscoveryDotDismissData));
    OCMStub([mock2 api_discoveryDotDismissTime]).andReturn([NSDate date]);
    OCMStub([mock2 api_discoveryDotModule]).andReturn(HMServiceAPIModuleMessageCenter);

    NSArray *mockDots = @[mock1, mock2];
    [[HMServiceAPI defaultService]
     discovery_dismissDots:mockDots
     completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoveryDotData>> *dots) {

         for (id<HMServiceAPIDiscoveryDotData>dot in dots) {
             NSLog(@"module is: %lu", dot.api_discoveryDotDataModule);
             NSLog(@"Update is: %d", (int)dot.api_discoveryDotDataUpdate);
             NSLog(@"messageCount is: %d", (int)dot.api_discoveryDotDataMessageCount);
         }

         [self handleTestResultWithAPIName:NSStringFromSelector(_cmd)
                                parameters:@{@"dots" : mockDots}
                                   success:success
                                   message:message
                                      data:nil];
         [expectation fulfill];
     }];

    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testSleepAdvertisement {

    XCTestExpectation *expectation = [self expectationWithDescription:@"testSleepAdvertisement"];

    id<HMCancelableAPI> api = [[HMServiceAPI defaultService]
                               discovery_sleepAdvertisementWithAdcode:@"340100"
                               completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIDiscoverySleepAdvertisementData>> *datas) {

                                   for (id<HMServiceAPIDiscoverySleepAdvertisementData>data in datas) {
                                       NSLog(@" LogoImageUrl is: %@", data.api_discoverySleepAdvertisementLogoImageUrl);
                                       NSLog(@" TopImageUrl is: %@", data.api_discoverySleepAdvertisementTopImageUrl);
                                       NSLog(@" BGImageUrl is: %@", data.api_discoverySleepAdvertisementBGImageUrl);
                                       NSLog(@" BannerImageUrl is: %@", data.api_discoverySleepAdvertisementBannerImageUrl);
                                       NSLog(@" WebviewUrl is: %@", data.api_discoverySleepAdvertisementWebviewUrl);
                                       NSLog(@" LogoWebviewUrl is: %@", data.api_discoverySleepAdvertisementLogoWebviewUrl);

                                       NSLog(@" Title is: %@", data.api_discoverySleepAdvertisementTitle);
                                       NSLog(@" SubTitle is: %@", data.api_discoverySleepAdvertisementSubTitle);
                                       NSLog(@" ID is: %@", data.api_discoverySleepAdvertisementID);
                                       NSLog(@" EndTime is: %@", data.api_discoverySleepAdvertisementEndTime);
                                       NSLog(@" Color is: %@", data.api_discoverySleepAdvertisementHomeColor);
                                       NSLog(@" BGColor is: %@", data.api_discoverySleepAdvertisementBGColor);
                                       NSLog(@" ThemeColor is: %@", data.api_discoverySleepAdvertisementThemeColor);

                                       NSLog(@"");
                                   }

                                   [expectation fulfill];
                               }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}

- (void)testAdvertisement {
    XCTestExpectation *expectation = [self expectationWithDescription:@"testSleepAdvertisement"];
    id<HMCancelableAPI> api = [[HMServiceAPI defaultService]
                               discovery_advertisementWithAdcode:@"340100"
                               type:HMServiceAPIAdvertisementTypeBodyFat
                               completionBlock:^(BOOL success, NSString *message, NSArray<id<HMServiceAPIAdvertisementData>> *datas) {

                                   for (id<HMServiceAPIAdvertisementData>data in datas) {

                                       NSLog(@" ID is: %@", data.api_advertisementID);
                                       NSLog(@" Title is: %@", data.api_advertisementTitle);
                                       NSLog(@" EndTime is: %@", data.api_advertisementEndTime);
                                       NSLog(@" SubTitle is: %@", data.api_advertisementSubTitle);
                                       NSLog(@" WebviewUrl is: %@", data.api_advertisementWebviewUrl);
                                       NSLog(@" LogoWebviewUrl is: %@", data.api_advertisementLogoWebviewUrl);
                                       NSLog(@" Image is: %@", data.api_advertisementImage);

                                       NSArray *colors = data.api_advertisementColors;
                                       for (id<HMServiceAPIAdvertisementColorData> color in colors) {

                                           NSLog(@" Color is: %@", color.api_advertisementColor);
                                           NSLog(@" ColorPosition is: %@", color.api_advertisementColorPosition);
                                       }

                                       NSArray *images = data.api_advertisementImages;
                                       for (id<HMServiceAPIAdvertisementImageData> image in images) {

                                           NSLog(@" ImageUrl is: %@", image.api_advertisementImageUrl);
                                           NSLog(@" ImagePosition is: %@", image.api_advertisementImagePosition);
                                       }

                                       NSLog(@"");
                                   }

                                   [expectation fulfill];
                               }];
    [api printCURL];
    [self waitForExpectations:@[expectation] timeout:60];
}



@end
