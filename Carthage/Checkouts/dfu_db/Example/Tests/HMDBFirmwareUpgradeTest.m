//  HMDBFirmwareUpgradeTest.m
//  Created on 21/12/2017
//  Description 固件升级单元测试

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <XCTest/XCTest.h>
#import <HMDBFirmwareUpgrade/HMDBFirmwareUpgradeBaseConfig.h>
#import <HMDBFirmwareUpgrade/HMDBFirmwareUpgradeManager.h>
#import <HMDBFirmwareUpgrade/HMDBFirmwareUpgradeInfoProtocol.h>
#import <OCMock/OCMock.h>


@interface HMDBFirmwareUpgradeTest : XCTestCase

@property(nonatomic,strong) HMDBFirmwareUpgradeManager *manager;

@end

@implementation HMDBFirmwareUpgradeTest

- (void)setUp {
    [super setUp];
    
    [HMDBFirmwareUpgradeBaseConfig configUserID:@"1000"];
   
    _manager = [[HMDBFirmwareUpgradeManager alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [HMDBFirmwareUpgradeBaseConfig clearDatabase];
    [super tearDown];
}

- (void)testAdd {
    [self dataGenerate];
    NSArray *arr = [_manager allInfos];
    
    XCTAssert(arr.count == 4);
}

- (void)testUpdate {
    [self dataGenerate];

    id <HMDBFirmwareUpgradeInfoProtocol> record = [_manager fetchInfoWithDeviceSource:0 fwFileType:0];
    XCTAssertNil(record);

    record = [_manager fetchInfoWithDeviceSource:1 fwFileType:1];
    XCTAssertNotNil(record);

    id protocolMock = [self dataGenerateWithTag:1];
    OCMStub([protocolMock dbProductVersion]).andReturn(100);

    NSError *error  = [_manager addOrUpdateFirmwareUpgradeInfo:protocolMock];
    XCTAssertNil(error);

    record = [_manager fetchInfoWithDeviceSource:1 fwFileType:1];
    XCTAssert(record.dbProductVersion == 100);
}

- (void)testQuery {
    [self dataGenerate];

    id <HMDBFirmwareUpgradeInfoProtocol> record = [_manager fetchInfoWithDeviceSource:0 fwFileType:0];
    XCTAssertNil(record);

    record = [_manager fetchInfoWithDeviceSource:1 fwFileType:1];
    XCTAssertNotNil(record);

    record = [_manager fetchInfoWithDeviceSource:1 fwFileType:0];
    XCTAssertNil(record);
}

- (void)testDelete {
    [self dataGenerate];
    [_manager removeInfoWithDeviceSource:1 fwFileType:1];

    id <HMDBFirmwareUpgradeInfoProtocol> record = [_manager fetchInfoWithDeviceSource:1 fwFileType:1];
    XCTAssertNil(record);
}

- (void)dataGenerate {
    id record1 = [self dataGenerateWithTag:1];
    OCMStub([record1 dbProductVersion]).andReturn(1);
    [_manager addOrUpdateFirmwareUpgradeInfo:record1];

    id record2 = [self dataGenerateWithTag:2];
    OCMStub([record2 dbProductVersion]).andReturn(1);
    [_manager addOrUpdateFirmwareUpgradeInfo:record2];

    id record3 = [self dataGenerateWithTag:3];
    OCMStub([record3 dbProductVersion]).andReturn(3);
    [_manager addOrUpdateFirmwareUpgradeInfo:record3];

    id record4 = [self dataGenerateWithTag:4];
    OCMStub([record4 dbProductVersion]).andReturn(4);
    [_manager addOrUpdateFirmwareUpgradeInfo:record4];

    // 重复添加
    [_manager addOrUpdateFirmwareUpgradeInfo:record1];
}

- (id)dataGenerateWithTag:(NSInteger)tag {
    id mockProtocol = OCMProtocolMock(@protocol(HMDBFirmwareUpgradeInfoProtocol));

    OCMStub([mockProtocol dbDeviceSource]).andReturn(tag);
    OCMStub([mockProtocol dbFirmwareVersion]).andReturn(@"");
    OCMStub([mockProtocol dbFirmwareName]).andReturn(@"");
    OCMStub([mockProtocol dbFirmwareURL]).andReturn(@"");
    OCMStub([mockProtocol dbFirmwareLocalPath]).andReturn(@"");
    OCMStub([mockProtocol dbFirmwareMD5]).andReturn(@"");
    OCMStub([mockProtocol dbFirmwareUpgradeType]).andReturn(0);

    OCMStub([mockProtocol dbLatestAbandonUpdateVersion]).andReturn(@"");
    OCMStub([mockProtocol dbIsCompressionFile]).andReturn(YES);
    OCMStub([mockProtocol dbIsShowDeviceRedPoint]).andReturn(YES);
    OCMStub([mockProtocol dbIsShowTabRedPoint]).andReturn(YES);
    OCMStub([mockProtocol dbLatestAbandonUpdateTime]).andReturn([NSDate date]);

    OCMStub([mockProtocol dbFirmwareFileType]).andReturn(tag);
    OCMStub([mockProtocol dbFirmwareLanguangeFamily]).andReturn(0);
    OCMStub([mockProtocol dbExtensionValue]).andReturn(@"");
    
    return mockProtocol;
}

@end
