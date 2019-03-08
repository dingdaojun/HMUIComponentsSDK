//
//  NSDictionaryCategory.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/23.
//  Copyright © 2017年 华米科技. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+HMJson.h"
#import "NSDictionary+HMSafe.h"


@interface NSDictionaryCategory : XCTestCase

@end

@implementation NSDictionaryCategory

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
    NSDictionary *dictionary = @{@"a": @"aa \n",
                                 @"b": @"bb \t",
                                 @"c": @"cc \r"};
    XCTAssertNotNil([dictionary toJSON:YES]);
    XCTAssertTrue([[dictionary toJSON:YES] isEqualToString:@"{\"a\":\"aa\",\"b\":\"bb\",\"c\":\"cc\"}"]);
    XCTAssertTrue([[dictionary toJSON:NO] isEqualToString:@"{\"a\":\"aa \\n\",\"b\":\"bb \\t\",\"c\":\"cc \\r\"}"]);
    XCTAssertTrue([[NSDictionary dictionaryWithJsonString:[dictionary toJSON:NO]] isEqualToDictionary:dictionary]);
}

- (void)testSafe {
    NSDictionary *dictionary = @{@"a": @"aa",
                                 @"b": @"bb",
                                 @"c": @"cc"};
    NSMutableDictionary *mulDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSArray *array = @[@"1", @"2"];
    
    
    XCTAssertNoThrow([mulDictionary setFloat:10.0 forKey:@"float"]);
    XCTAssertNoThrow([mulDictionary setInteger:1 forKey:@"integer"]);
    XCTAssertNoThrow([mulDictionary setBool:YES forKey:@"BOOL"]);
    XCTAssertNoThrow([mulDictionary setSafeObject:nil forKey:nil]);
    XCTAssertNoThrow([mulDictionary setSafeObject:@"[\"1\", \"2\"]" forKey:@"array"]);
    XCTAssertNoThrow([mulDictionary setSafeObject:@"{\"a\":\"aa\",\"b\":\"bb\",\"c\":\"cc\"}" forKey:@"dictionary"]);
    
    XCTAssertTrue([[mulDictionary stringForKey:@"a"] isEqualToString:@"aa"]);
    XCTAssertTrue([mulDictionary floatForKey:@"float"] == 10.0);
    XCTAssertTrue([mulDictionary integerForKey:@"integer"] == 1);
    XCTAssertTrue([[mulDictionary arrayForKey:@"array"] isEqualToArray:array]);
    XCTAssertTrue([[mulDictionary dictionaryForKey:@"dictionary"] isEqualToDictionary:dictionary]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
