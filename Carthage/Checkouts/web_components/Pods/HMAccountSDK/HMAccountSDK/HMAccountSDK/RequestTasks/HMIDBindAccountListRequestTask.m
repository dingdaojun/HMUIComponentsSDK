//
//  HMIDBindAccountListRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDBindAccountListRequestTask.h"
#import "HMIDBindItem.h"

@interface HMIDBindAccountListRequestTask ()

@property (nonatomic, copy) NSString *appToken;

@end

@implementation HMIDBindAccountListRequestTask

- (instancetype)initWithAppToken:(NSString *)appToken {
    self = [super init];
    if (self) {
        self.appToken = appToken;
    }
    return self;
}

- (NSString *)apiName{
    return @"/v1/client/list_accounts";
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.appToken]) {
        return [NSError wsLocalParamErrorKey:@"appToken"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    [self.parameter setObject:self.appToken forKey:@"app_token"];
    [self.parameter setObject:[HMAccountTools appVersion] forKey:@"os_version"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    [super parseResponseHanlderWithDictionary:infoDict];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *bindInfo = infoDict[@"data"];
    for (NSDictionary *dict in bindInfo) {
        HMIDBindItem *bindItem = [[HMIDBindItem alloc] initWithDict:dict];
        [array addObject:bindItem];
    }
    self.resultItems = array;
}

@end
