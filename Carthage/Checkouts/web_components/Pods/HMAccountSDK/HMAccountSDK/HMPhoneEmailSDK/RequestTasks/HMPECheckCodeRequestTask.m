//
//  HMPECheckCodeRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2018/1/10.
//  Copyright © 2018年 LiLingang. All rights reserved.
//

#import "HMPECheckCodeRequestTask.h"

@interface HMPECheckCodeRequestTask ()

@property (nonatomic, copy) HMPECodeType *codeType;

@property (nonatomic, copy) NSString *code;

@end

@implementation HMPECheckCodeRequestTask

+ (nonnull HMPECheckCodeRequestTask *)phoneTaskWithAreaCode:(nonnull NSString *)areaCode
                                                      phone:(nonnull NSString *)phone
                                                   codeType:(nonnull HMPECodeType *)codeType
                                                       code:(nonnull NSString *)code {
    HMPECheckCodeRequestTask *requestTask = [[HMPECheckCodeRequestTask alloc] initWithAreaCode:areaCode account:phone region:nil];
    requestTask.codeType = codeType;
    requestTask.code = code;
    return requestTask;
}

- (NSString *)apiName {
    return [NSString stringWithFormat:@"/registrations/%@/%@/verify",self.account,self.codeType];
}

- (WSHTTPMethod)requestMethod {
    return WSHTTPMethodPOST;
}

- (NSError *)validLocalParameterField {
    if (!self.codeType) {
        return [NSError wsLocalParamErrorKey:@"codeType"];
    }
    if (!self.code) {
        return [NSError wsLocalParamErrorKey:@"code"];
    }
    return [super validLocalParameterField];
}

- (void)configureParameterField {
    [super configureParameterField];
    [self.parameter setObject:self.code forKey:@"code"];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict {
    [super parseResponseHanlderWithDictionary:infoDict];
    self.resultItem = infoDict[@"code"];
}

@end
