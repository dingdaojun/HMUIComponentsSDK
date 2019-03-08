//
//  NSStringCategory.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/18.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HMCategoryKit.h"


@interface NSStringCategory : XCTestCase

@end

@implementation NSStringCategory

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIpAddress {
    XCTAssertNotNil([NSString ipAddress]);
    //XCTAssertEqualObjects([NSString ipAddress], @"10.8.6.247");
    NSString *macAddress = [NSString getMacAddress];
    NSLog(@"macAddress=%@",macAddress);
    XCTAssertNotNil(macAddress, @"mac地址获取失败");
}

- (void)testPinyin {
    XCTAssertEqualObjects([@"中国" pinyin], @"zhongguo");
    XCTAssertEqualObjects([@"小娜" pinyin], @"xiaona");
}

- (void)testHMApp {
    XCTAssertEqualObjects([NSString appDisplayName], @"源码测试");
    XCTAssertEqualObjects([NSString appVersion], @"1.0");
    XCTAssertEqualObjects([NSString appBuildVersion], @"1");
    XCTAssertNotNil([NSString documentsPath], @"documentsPath error");
    XCTAssertNotNil([NSString tmpPath], @"tmpPath error");
    XCTAssertNotNil([NSString cachesPath], @"cachesPath error");
}

- (void)testHMHexData {
    NSString *macAddress = [NSString getMacAddress];
    NSLog(@"macAddress=%@",macAddress);
    NSString *peripheralMacAddress = [macAddress peripheralMacAddress];
    NSLog(@"peripheralMacAddress =======%@", peripheralMacAddress);
    XCTAssertFalse([peripheralMacAddress containsString:@":"]);
    NSString *formatMacAddress = [peripheralMacAddress formatPeripheralMacAddress];
    XCTAssertEqualObjects(formatMacAddress, macAddress);
    
    
    XCTAssertFalse([@"1.4.9.0" isEqualToFirmwareVersion:@"1.4.9.1"]);
    XCTAssertTrue([@"1.4.9.4" isEqualToFirmwareVersion:@"1.4.9.1"]);
    XCTAssertTrue([@"1.4.9.0" isEqualToFirmwareVersion:@"1.4.9"]);
    XCTAssertTrue([@"1.4.9.0" isEqualToFirmwareVersion:@"1.4.9.0"]);
    
}

- (void)testHMJudge {
    XCTAssertTrue([NSString isEmpty:@""]);
    XCTAssertFalse([NSString isEmpty:@"adas"]);
    XCTAssertTrue([NSString isEmpty:nil]);
    
    XCTAssertTrue([@"98@qq.com" isValidEmail]);
    XCTAssertFalse([@"@q.com" isValidEmail]);
    XCTAssertFalse([@"98q.com" isValidEmail]);
    XCTAssertFalse([@"98@.c" isValidEmail]);
    XCTAssertFalse([@"98@.com" isValidEmail]);
    
    XCTAssertTrue([@"2121" isPureInt]);
    XCTAssertTrue([@"0121" isPureInt]);
    XCTAssertTrue([@"0" isPureInt]);
    XCTAssertTrue([@"1" isPureInt]);
    XCTAssertFalse([@"1.1" isPureInt]);
    
    XCTAssertTrue([@"1.1" isPureFloat]);
    XCTAssertTrue([@"0" isPureFloat]);
    XCTAssertTrue([@"1" isPureFloat]);
    
    XCTAssertTrue([@"1782371" isOnlyContainNumber]);
    XCTAssertFalse([@"03718319a31" isOnlyContainNumber]);
    
    XCTAssertTrue([@"http://www.baidu.com" isValidURL]);
    XCTAssertFalse([@"www.baidu.com" isValidURL]);
    XCTAssertFalse([@"QASAS" isValidURL]);
}

- (void)testHMEncryption {
    XCTAssertTrue([[@"华米科技" md5ForLower32Bate] isEqualToString:@"b96a545a36220dede589c3111de5466d"]);
    XCTAssertTrue([[@"华米科技" md5ForUpper32Bate] isEqualToString:@"B96A545A36220DEDE589C3111DE5466D"]);
    XCTAssertTrue([[@"华米科技" md5ForLower16Bate] isEqualToString:@"36220dede589c311"]);
    XCTAssertTrue([[@"华米科技" md5ForUpper16Bate] isEqualToString:@"36220DEDE589C311"]);
    
    NSString *encodeString = [@"华米科技" base64Encode];
    NSLog(@"base64Encode===%@", encodeString);
    XCTAssertTrue([encodeString isEqualToString:@"5Y2O57Gz56eR5oqA"]);
    XCTAssertTrue([[encodeString base64Decode] isEqualToString:@"华米科技"]);
}

- (void)testHMAdjust {
    XCTAssertTrue([[@" 1 2 " trimEndsSpace] isEqualToString:@"1 2"]);
    XCTAssertTrue([[@" 1 2 3 " trimAllSpace] isEqualToString:@"123"]);
    XCTAssertTrue([[@"\n\t\r" trimSpecialCode] isEqualToString:@""]);
    
    NSString *jsonString = @"{\"a\":123, \"b\":\"abc\"}";
    XCTAssertTrue([[jsonString toDictionaryWithError:nil] integerForKey:@"a"] == 123);
    
    NSString *jsonArrayString = @"[{\"a\":123, \"b\":\"abc\"}, {\"a\":123, \"b\":\"abc\"}]";
    XCTAssertTrue([jsonArrayString toArrayWithError:nil].count == 2);
    XCTAssertTrue([[jsonArrayString toArrayWithError:nil].firstObject integerForKey:@"a"] == 123);
}

- (void)testHMURL {
    // 可以在这里看看是否正确: http://tool.oschina.net/encode?type=4 encodeURIComponent
    NSString *urlString = @"http://www.oschina.net/search?scope=bbs&q=C语言";
    NSString *encodeURLString = [urlString encodeToPercentEscapeString];
    NSLog(@"encodeURLString=====%@",encodeURLString);
    XCTAssertTrue([encodeURLString isEqualToString:@"http%3A%2F%2Fwww.oschina.net%2Fsearch%3Fscope%3Dbbs%26q%3DC%E8%AF%AD%E8%A8%80"]);
    XCTAssertTrue([[encodeURLString decodeFromPercentEscapeString] isEqualToString:urlString]);
}

//TODO:bounds value cases
- (void)testUnGregorianDateStringToDate {

    //2017-10-19按日本平成历法读取转公元纪年
    NSString *japanUT1 = @"4005-10-19";
    NSDate *japanDate1 = [japanUT1 unGregorianDateStringToDate];
    XCTAssertEqual(japanDate1.year, 2017);
    XCTAssertTrue([[japanDate1 stringWithFormat_yyyyMMdd] isEqualToString:@"2017-10-19"]);

    //日本平成29年转公元纪年
    NSString *japanUT2 = @"29-10-19";
    NSDate *japanDate2 = [japanUT2 unGregorianDateStringToDate];
    XCTAssertEqual(japanDate2.year, 2017);
    XCTAssertTrue([[japanDate2 stringWithFormat_yyyyMMdd] isEqualToString:@"2017-10-19"]);

    //2017-10-19按佛历读取转公元纪年
    NSString *foUT1 = @"1474-10-19";
    NSDate *foDate1 = [foUT1 unGregorianDateStringToDate];
    XCTAssertEqual(foDate1.year, 2017);
    XCTAssertTrue([[foDate1 stringWithFormat_yyyyMMdd] isEqualToString:@"2017-10-19"]);

    //佛历2560年转公元纪年
    NSString *foUT2 = @"2560-10-19";
    NSDate *foDate2 = [foUT2 unGregorianDateStringToDate];
    XCTAssertEqual(foDate2.year, 2017);
    XCTAssertTrue([[foDate2 stringWithFormat_yyyyMMdd] isEqualToString:@"2017-10-19"]);
}

- (void)testDevice {
    //
    NSString *deviceName = [UIDevice deviceName];
    XCTAssertTrue([deviceName isEqualToString:@"Simulator"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
