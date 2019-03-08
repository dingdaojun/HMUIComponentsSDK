//
//  HMPEBaseRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEBaseRequestTask.h"
#import "HMAccountConfig.h"
#import "HMPEConfig.h"

@interface HMPEBaseRequestTask ()
/**
 Query 尽可能的避免冲突参数，MilliSeconds since 1970
 */
@property (nonnull, nonatomic, strong) NSString *t;

/**
 国家电话区号(手机账号不能为nil) eg 中国 +86 or 86
 */
@property (nullable, nonatomic, strong) NSString *areaCode;

/**
 账号，phone or email
 */
@property (nonnull, nonatomic, strong, readwrite) NSString *account;

/**
 国家地区码，https://en.wikipedia.org/wiki/ISO_3166-1，采用国际标准
 */
@property (nullable, nonatomic, strong) NSString *region;

@end

@implementation HMPEBaseRequestTask

- (nonnull instancetype)initWithAreaCode:(nullable NSString *)areaCode
                                 account:(nonnull NSString *)account
                                  region:(nullable NSString *)region {
    self = [super init];
    if (self) {
        self.areaCode = areaCode;
        self.account = account;
        self.region = region ? region : [HMAccountTools countryCode];
        self.ignoreHeaderKeys = @[WSHTTPHeaderKey_AcceptLanguage];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.accountType = HMPEAccountTypeUnkown;
        self.ignoreHeaderKeys = @[WSHTTPHeaderKey_AcceptLanguage];
    }
    return self;
}

- (NSURL *)baseUrl{
    return [NSURL URLWithString:[HMAccountConfig phoneEmailAccountServerHost]];
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
    if (self.accountType == HMPEAccountTypeUnkown) {
        return [NSError wsLocalParamErrorKey:@"accountType"];
    }
    if (self.accountType == HMPEAccountTypePhone && [HMAccountTools isEmptyString:self.areaCode]) {
        return [NSError wsLocalParamErrorKey:@"areaCode"];
    }
    if ([HMAccountTools isEmptyString:_account]) {
        return [NSError wsLocalParamErrorKey:@"account"];
    }
    if (self.shouldHookRedirection && [HMAccountTools isEmptyString:[HMPEConfig sharedInstance].redirectURI]) {
        return [NSError wsLocalParamErrorKey:@"redirectURI"];
    }
    return nil;
}

- (void)configureParameterField{
    [super configureParameterField];
    if ([HMPEConfig sharedInstance].r) {
        [self.parameter setObject:[HMPEConfig sharedInstance].r forKey:@"r"];
    }
    [self.parameter setObject:self.t forKey:@"t"];
    if (self.region) {
        [self.parameter setObject:self.region forKey:@"country_code"];
    }
    if (self.shouldHookRedirection) {
        [self.parameter setObject:[HMPEConfig sharedInstance].redirectURI forKey:@"redirect_uri"];
    }
}

- (NSError *)cumstomResposeRawObjectValidator {
    if ([self.responseRawObject isKindOfClass:[NSDictionary class]]) {
        NSString *errorCodeString = self.responseRawObject[@"error"];
        if (errorCodeString) {
            NSInteger errorCode = [errorCodeString integerValue];
            NSError *error = [NSError errorWithDomain:@"com.huami.PEAccount" code:errorCode userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"PEAccount Error code(%@)",errorCodeString]}];
            return error;
        } else {
            [self parseResponseHanlderWithDictionary:self.responseRawObject];
        }
    }
    return [super cumstomResposeRawObjectValidator];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict {
    
}

#pragma mark - Getter and Setter

- (NSString *)account{
    if (self.accountType == HMPEAccountTypePhone) {
        if (![self.areaCode hasPrefix:@"+"]) {
            self.areaCode = [@"+" stringByAppendingString:self.areaCode];
        }
        return  [self.areaCode stringByAppendingString:_account];
    } else {
        return _account;
    }
}

- (NSString *)t{
    if (!_t) {
        uint64_t milliSeconds = (uint64_t)ceil([[NSDate date] timeIntervalSince1970] * 1000);
        _t = [@(milliSeconds) stringValue];
    }
    return _t;
}

@end
