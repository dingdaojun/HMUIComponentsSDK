//  HMDBAdGeneralTest.m
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import <XCTest/XCTest.h>
#import <HMDBAdvertisement/HMDBAdServices+General.h>
#import <HMDBAdvertisement/HMDBAdGeneralResourceProtocol.h>
#import <HMDBAdvertisement/HMDBAdGeneralProtocol.h>
#import <HMDBAdvertisement/HMDBAdvertisementConfig.h>
#import <OCMock/OCMock.h>

@interface HMDBAdGeneralTest : XCTestCase

@end

@implementation HMDBAdGeneralTest

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
    id instanceOne = [self generateInstanceWithAID:@"1" module:HMDBAdModuleTypeSleep];
    id instanceTwo = [self generateInstanceWithAID:@"2" module:HMDBAdModuleTypeSleep];
    
    HMDBAdServices *service = [[HMDBAdServices alloc] init];
    
    BOOL isSuccess = [service addGeneralAd:instanceOne];
    XCTAssertTrue(isSuccess);
    
    [service addGeneralAd:instanceTwo];
    XCTAssertTrue(isSuccess);
    
    id instanceThree = [self generateInstanceWithAID:@"1" module:HMDBAdModuleTypeSleep];
    isSuccess = [service addGeneralAd:instanceThree];
    XCTAssertFalse(isSuccess);
    
    id instanceFour = [self generateInstanceWithAID:@"1" module:HMDBAdModuleTypeBodyFit];
    isSuccess = [service addGeneralAd:instanceFour];
    XCTAssertTrue(isSuccess);
}

- (void)testDelete {
    [self testAdd];
    
    HMDBAdServices *service = [[HMDBAdServices alloc] init];
    NSArray *arr = [service allModuleAds:HMDBAdModuleTypeSleep];
    XCTAssert(arr.count == 2);
    
    BOOL isSuccess = [service deleteGeneralAdWithAdvertisementID:@"1" moduleType:HMDBAdModuleTypeSleep];
    XCTAssertTrue(isSuccess);
    arr = [service allModuleAds:HMDBAdModuleTypeSleep];
    XCTAssert(arr.count == 1);
    
    arr = [service allModuleAds:HMDBAdModuleTypeBodyFit];
    XCTAssert(arr.count == 1);
    
    arr = [service allGeneralAds];
    XCTAssert(arr.count == 2);
    
    isSuccess = [service deleteModuleAds:HMDBAdModuleTypeBodyFit];
    XCTAssertTrue(isSuccess);
    
    arr = [service allModuleAds:HMDBAdModuleTypeBodyFit];
    XCTAssert(arr.count == 0);
}

- (id)generateInstanceWithAID:(NSString *)aid module:(HMDBAdModuleType)moduleType {
    id protocolMock = OCMStrictProtocolMock(@protocol(HMDBAdGeneralProtocol));
    
    OCMStub([protocolMock db_adID]).andReturn(aid);
    OCMStub([protocolMock db_adModuleType]).andReturn(moduleType);
    OCMStub([protocolMock db_adWebviewUrl]).andReturn(@"");
    OCMStub([protocolMock db_adLogoWebviewUrl]).andReturn(@"");
    OCMStub([protocolMock db_adGeneralImage]).andReturn(@"");
    OCMStub([protocolMock db_adTitle]).andReturn(@"");
    OCMStub([protocolMock db_adSubTitle]).andReturn(@"");
    OCMStub([protocolMock db_adEndTime]).andReturn([NSDate date]);
    
    id resourceImageMock1 = OCMStrictProtocolMock(@protocol(HMDBAdGeneralResourceProtocol));
    OCMStub([resourceImageMock1 db_resourceValue]).andReturn(@"resourceValue");
    OCMStub([resourceImageMock1 db_displayPositon]).andReturn(@"displayPositon");
    
    id resourceImageMock2 = OCMStrictProtocolMock(@protocol(HMDBAdGeneralResourceProtocol));
    OCMStub([resourceImageMock2 db_resourceValue]).andReturn(@"resourceValue");
    OCMStub([resourceImageMock2 db_displayPositon]).andReturn(@"displayPositon");
    
    id resourceColorMock1 = OCMStrictProtocolMock(@protocol(HMDBAdGeneralResourceProtocol));
    OCMStub([resourceColorMock1 db_resourceValue]).andReturn(@"resourceValue");
    OCMStub([resourceColorMock1 db_displayPositon]).andReturn(@"displayPositon");
    
    id resourceColorMock2 = OCMStrictProtocolMock(@protocol(HMDBAdGeneralResourceProtocol));
    OCMStub([resourceColorMock2 db_resourceValue]).andReturn(@"resourceValue");
    OCMStub([resourceColorMock2 db_displayPositon]).andReturn(@"displayPositon");

    NSArray *images = @[resourceImageMock1,resourceImageMock2];
    NSArray *colors = @[resourceColorMock1,resourceColorMock2];
    OCMStub([protocolMock db_adImages]).andReturn(images);
    OCMStub([protocolMock db_adColors]).andReturn(colors);
    
    return protocolMock;
}

@end
