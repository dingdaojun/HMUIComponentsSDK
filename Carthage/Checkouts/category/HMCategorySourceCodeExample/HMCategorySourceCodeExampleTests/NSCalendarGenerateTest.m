//  NSCalendarGenerateTest.m
//  Created on 2018/11/16
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author zhanggui(zhanggui@huami.com)

#import <XCTest/XCTest.h>
#import "NSCalendar+HMGenerate.h"

@interface NSCalendarGenerateTest : XCTestCase

@end

@implementation NSCalendarGenerateTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int i = 0;
        while (i < 10000) {
            __unused NSCalendar *calendar = [NSCalendar gregorianCalendar];
            i++;
        }
    }];
}

@end
