//  HMServiceAPI+WalletHandleResult.h
//  Created on 2018/3/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>


@interface HMServiceAPI (WalletHandleResult)


- (void)walletHandleResultForAPI:(SEL)API
                   responseError:(NSError *)responseError
                        response:(NSURLResponse *)response
                  responseObject:(id)responseObject
                 completionBlock:(void (^)(NSString *status, NSString *message, id data))completionBlock;



@end
