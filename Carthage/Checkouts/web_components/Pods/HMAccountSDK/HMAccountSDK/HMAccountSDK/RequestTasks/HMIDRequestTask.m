//
//  HMIDRequestTask.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"
#import "NSError+HMAccountSDK.h"
#import "HMIDHostStore.h"
#import "HMAccountConfig.h"
#import "HMAccountLogger.h"

@implementation HMIDRequestTask

- (NSURL *)baseUrl{
    NSString *cacheHost = [HMIDHostStore currentUseHost];
    if (!cacheHost) {
        //缓存没有认为是国内用户
        cacheHost = [HMAccountConfig idAccountCNServerHost];
    }
    return [NSURL URLWithString:cacheHost];
}

- (WSRequestContentType)requestSerializerType{
    return WSRequestContentTypeURLEncoded;
}

- (void)configureHeaderField {
    [super configureHeaderField];
    [self.headerDictionary addEntriesFromDictionary:[HMAccountConfig customHeader]];
}

- (void)parseResponseHanlderWithDictionary:(NSDictionary *)infoDict{
    
}

- (NSError *)cumstomResposeRawObjectValidator {
    NSError *error = [super cumstomResposeRawObjectValidator];
    if (error) {
        return error;
    }
    if ([self.responseRawObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutaResponse = [self.responseRawObject mutableCopy];
        if (mutaResponse[@"error_code"] || mutaResponse[@"errorCode"] || mutaResponse[@"code"]) {
#ifdef DDLogError
            DDLogError(@"HMAccountSDK [%@]\n HEAD:%@\nparam:%@\nResponseObject:%@\nresult:%@",NSStringFromClass([self class]),self.headerDictionary,self.parameter,self.httpURLResponse,mutaResponse);
#else
            HMAccountLogError(@"HMAccountSDK [%@]\n HEAD:%@\nparam:%@\nResponseObject:%@\nresult:%@",NSStringFromClass([self class]),self.headerDictionary,self.parameter,self.httpURLResponse,mutaResponse);
#endif
            if (mutaResponse[@"errorCode"]) {
                [mutaResponse setObject:mutaResponse[@"errorCode"] forKey:@"code"];
                [mutaResponse removeObjectForKey:@"errorCode"];
            }
            if (mutaResponse[@"error_code"]) {
                [mutaResponse setObject:mutaResponse[@"error_code"] forKey:@"code"];
                [mutaResponse removeObjectForKey:@"error_code"];
            }
            NSString *code = mutaResponse[@"code"];
            if ([code isEqualToString:@"0000"]) {
                //也为正确的情况，只有验证token的时候会用到
                [mutaResponse removeObjectForKey:@"code"];
                self.responseRawObject = [mutaResponse copy];
                [self parseResponseHanlderWithDictionary:self.responseRawObject];
                return nil;
            } else {
                self.responseRawObject = [mutaResponse copy];
                NSError *error = [NSError idErrorWithIDResponseObject:mutaResponse];
                return error;
            }
        } else {
            NSLog(@"HMAccountSDK [%@]\n HEAD:%@\nparam:%@\nResponseObject:%@",NSStringFromClass([self class]),self.headerDictionary,self.parameter,mutaResponse);
            [self parseResponseHanlderWithDictionary:self.responseRawObject];
            return nil;
        }
    } else {
        return [NSError wsResponseFormatError];
    }
}

- (void)handleError:(NSError *)error {
    error.idhttpURLResponse = self.httpURLResponse;
    error.idIpAddress = self.ipAddress;
}
@end
