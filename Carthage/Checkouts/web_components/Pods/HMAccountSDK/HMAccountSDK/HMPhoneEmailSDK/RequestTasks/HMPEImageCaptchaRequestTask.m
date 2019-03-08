//
//  HMPEImageCaptchaRequestTask.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/11/20.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMPEImageCaptchaRequestTask.h"
#import "HMAccountConfig.h"
#import "HMPEConfig.h"

@interface HMPEImageCaptchaRequestTask ()

@property (nonatomic, copy) NSString *t;

@property (nonatomic, copy) HMPEImageCodeType *codeType;

@end

@implementation HMPEImageCaptchaRequestTask

+ (nonnull HMPEImageCaptchaRequestTask *)captchTaskWithCodeType:(nonnull HMPEImageCodeType *)codeType {
    HMPEImageCaptchaRequestTask *requestTask = [[HMPEImageCaptchaRequestTask alloc] init];
    requestTask.codeType = codeType;
    return requestTask;
}

#pragma mark - Private Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        self.ignoreHeaderKeys = @[WSHTTPHeaderKey_AcceptLanguage];
    }
    return self;
}

- (NSURL *)baseUrl{
    return [NSURL URLWithString:[HMAccountConfig phoneEmailAccountServerHost]];
}

- (NSString *)apiName{
    return [NSString stringWithFormat:@"/captcha/%@",self.codeType];
}

- (WSHTTPMethod)requestMethod{
    return WSHTTPMethodGET;
}

- (WSRequestContentType)requestSerializerType{
    return WSRequestContentTypeURLEncoded;
}

- (void)configureHeaderField {
    [super configureHeaderField];
    [self.headerDictionary setObject:[HMPEConfig sharedInstance].appName forKey:@"app_name"];
    [self.headerDictionary addEntriesFromDictionary:[HMAccountConfig customHeader]];
}

- (NSError *)validLocalParameterField{
    NSError *error = [super validLocalParameterField];
    if (error) {
        return error;
    }
    if ([HMAccountTools isEmptyString:self.codeType]) {
        return [NSError wsLocalParamErrorKey:@"codeType"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    if ([HMPEConfig sharedInstance].r) {
        [self.parameter setObject:[HMPEConfig sharedInstance].r forKey:@"r"];
    }
    [self.parameter setObject:self.t forKey:@"t"];
}

- (WSResponseMIMEType)responseSerializerType {
    return WSResponseMIMETypeImage;
}

- (NSError *)cumstomResposeRawObjectValidator {
    if ([self.responseRawObject isKindOfClass:[UIImage class]]) {
        self.resultItem = self.responseRawObject;
        return nil;
    }
    return [super cumstomResposeRawObjectValidator];
}


#pragma mark - Getter and Setter

- (NSString *)t{
    if (!_t) {
        uint64_t milliSeconds = (uint64_t)ceil([[NSDate date] timeIntervalSince1970] * 1000);
        _t = [@(milliSeconds) stringValue];
    }
    return _t;
}
@end
