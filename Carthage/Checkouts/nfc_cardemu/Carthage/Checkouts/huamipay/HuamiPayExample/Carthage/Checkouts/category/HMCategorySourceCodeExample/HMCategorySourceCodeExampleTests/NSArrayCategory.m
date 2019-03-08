//
//  NSArrayCategory.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/22.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+HMJson.h"
#import "NSArray+HMSafe.h"


@interface NSArrayCategory : XCTestCase

@end

@implementation NSArrayCategory

- (void)setUp {
    [super setUp];
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

- (void)testToJson {
    NSArray *array = @[@"a  \n", @"b\t", @"c\r"];
    
    XCTAssertTrue([[array toJSON:NO] isEqualToString:@"[\"a  \\n\",\"b\\t\",\"c\\r\"]"]);
    XCTAssertTrue([[array toJSON:YES] isEqualToString:@"[\"a\",\"b\",\"c\"]"]);
}

- (void)testToData {
    NSArray *array = @[@"a  \n", @"b\t", @"c\r"];
    XCTAssertNotNil([array toJSONData]);
}

- (void)testSafe {
    NSArray *array = @[@"a", @"b", @"c", @"d"];
    XCTAssertNil([array objectAtSafeIndex:array.count]);
    
    NSMutableArray *mulArray = [NSMutableArray arrayWithArray:array];
    XCTAssertNoThrow([mulArray addSafeObject:nil]);
    XCTAssertNoThrow([mulArray insertSafeObject:nil atIndex:10]);
    XCTAssertNoThrow([mulArray removeObjectAtSafeIndex:10]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
