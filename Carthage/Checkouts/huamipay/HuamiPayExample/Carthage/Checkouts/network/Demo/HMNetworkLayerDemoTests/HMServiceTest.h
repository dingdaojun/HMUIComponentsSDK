//  HMServiceTest.h
//  Created on 2018/3/17
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <XCTest/XCTest.h>
#import <HMService/HMService.h>



@interface HMServiceTest : XCTestCase <HMServiceDelegate>


- (NSString *)userID;
- (NSString *)host;
- (NSString *)appToken;

- (void)handleTestResultWithAPIName:(NSString *)name
                         parameters:(NSDictionary *)parameters
                            success:(BOOL)success
                            message:(NSString *)message
                               data:(id)data;


@end

