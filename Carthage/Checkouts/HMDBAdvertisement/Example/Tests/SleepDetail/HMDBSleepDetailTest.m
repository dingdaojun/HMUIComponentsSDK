//  HMDBSleepDetailTest.m
//  Created on 2018/5/31
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBAdvertisement/HMDBAdServices+SleepDetail.h>
#import <HMDBAdvertisement/HMDBAdSleepDetailProtocol.h>
#import <HMDBAdvertisement/HMDBAdvertisementConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBSleepDetailTest : XCTestCase

@end

@implementation HMDBSleepDetailTest

- (void)setUp {
    [super setUp];
    [HMDBAdvertisementConfig configUserID:@"1000"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [HMDBAdvertisementConfig clearDatabase];
}

- (void)testAdd {
    id instanceOne = [self generateInstanceWithAID:@"1"];
    id instanceTwo = [self generateInstanceWithAID:@"2"];

    HMDBAdServices *service = [[HMDBAdServices alloc] init];

    BOOL isSuccess = [service addSleepDetailAds:@[instanceOne,instanceTwo]];
    XCTAssertTrue(isSuccess);
    
    id instanceThree = [self generateInstanceWithAID:@"1"];
    isSuccess = [service addSleepDetailAds:@[instanceThree]];
    XCTAssertFalse(isSuccess);
}

- (void)testDelete {
    [self testAdd];

    HMDBAdServices *service = [[HMDBAdServices alloc] init];
    NSArray *arr = [service allSleepDetailAds];
    XCTAssert(arr.count == 2);

    [service deleteSleepDetailWithAdvertisementID:@"1"];
    arr = [service allSleepDetailAds];
    XCTAssert(arr.count == 1);
}

- (id)generateInstanceWithAID:(NSString *)aid {
    id protocolMock = OCMStrictProtocolMock(@protocol(HMDBAdSleepDetailProtocol));

    OCMStub([protocolMock db_advertisementID]).andReturn(aid);
    OCMStub([protocolMock db_logoImageURL]).andReturn(@"");
    OCMStub([protocolMock db_topImageURL]).andReturn(@"");
    OCMStub([protocolMock db_analysisImageURL]).andReturn(@"");
    OCMStub([protocolMock db_bannerImageURL]).andReturn(@"");


    OCMStub([protocolMock db_title]).andReturn(@"");
    OCMStub([protocolMock db_subTitle]).andReturn(@"");
    OCMStub([protocolMock db_backgroundColorHex]).andReturn(@"");
    OCMStub([protocolMock db_homeColorHex]).andReturn(@"");

    OCMStub([protocolMock db_themeColorHex]).andReturn(@"");
    OCMStub([protocolMock db_webviewLinkURL]).andReturn(@"");
    OCMStub([protocolMock db_logoLinkURL]).andReturn(@"");

    OCMStub([protocolMock db_endDate]).andReturn([NSDate date]);

    return protocolMock;
}

@end
