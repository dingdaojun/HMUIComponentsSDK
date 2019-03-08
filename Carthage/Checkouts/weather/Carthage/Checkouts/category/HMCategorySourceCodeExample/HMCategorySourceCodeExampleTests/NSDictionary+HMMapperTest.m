//  NSDictionary+HMMapperTest.m
//  Created on 2018/3/5
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#import <XCTest/XCTest.h>
#import "NSDictionary+HMMapper.h"

@interface NSDictionary_HMMapperTest : XCTestCase

@end

@implementation NSDictionary_HMMapperTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testString {
    NSDictionary *sut = @{@"k":@"v"};
    XCTAssertTrue([sut.hmmap[@"k"].string isEqualToString:@"v"]);
}

- (void)testNumber {
    NSDictionary *sut = @{@"k": @100};
    XCTAssertTrue([sut.hmmap[@"k"].number isEqualToNumber:@100]);
}

- (void)testBoolean {
    NSDictionary *sut = @{@"k": @0};
    XCTAssertTrue(sut.hmmap[@"k"].boolean == false);
}

- (void)testArray {
    NSArray *array = @[@"v1", @"v2", @"v3"];
    NSDictionary *sut = @{@"k": array};
    XCTAssertTrue([sut.hmmap[@"k"].array isEqualToArray:array]);
}

- (void)testDictionary {
    NSDictionary *dictionary = @{@"k1":@"v1", @"k2":@"v2", @"k3":@"v3"};
    NSDictionary *sut = @{@"k": dictionary};
    XCTAssertTrue([sut.hmmap[@"k"].dictionary isEqualToDictionary:dictionary]);
}

- (void)testUnsignedIntegerValue {
    NSDictionary *sut = @{@"k": @100};
    XCTAssertTrue(sut.hmmap[@"k"].unsignedIntegerValue == 100);
}

- (void)testintegerValue {
    NSDictionary *sut = @{@"k": @(-100)};
    XCTAssertTrue(sut.hmmap[@"k"].integerValue == -100);
}

- (void)testDoubleValue {
    double value = 100.00001;
    NSDictionary *sut = @{@"k": @(value)};
    XCTAssertTrue(sut.hmmap[@"k"].doubleValue == value);
}

- (void)testBase64Data {
    //TODO:
}

- (void)testColor {
    //TODO:
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
