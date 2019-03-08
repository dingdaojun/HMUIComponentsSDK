//  HMServiceAPI+WalletHandleResult.m
//  Created on 2018/3/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+WalletHandleResult.h"

@implementation HMServiceAPI (WalletHandleResult)

- (void)walletHandleResultForAPI:(SEL)API
                   responseError:(NSError *)responseError
                        response:(NSURLResponse *)response
                  responseObject:(id)responseObject
                 completionBlock:(void (^)(NSString *status, NSString *message, id data))completionBlock {

    [self handleResultForAPI:API
               responseError:responseError
                    response:response
              responseObject:responseObject
           desiredDataFormat:HMServiceResultDataFormatDictionary
             completionBlock:^(BOOL success, NSString *message, NSDictionary *data) {

                 if (!success) {
                     completionBlock(nil, message, data);
                     return;
                 }

                 NSString *status = data.hmjson[@"resp_code"].string;
                 id walletData = responseObject[@"resp_data"];;
                 NSString *walletMessage = data.hmjson[@"resp_msg"].string;
                 completionBlock(status, walletMessage, walletData);
             }];
}

@end
