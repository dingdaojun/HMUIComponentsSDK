//
//  HMServiceAPI+UnderageAccount.h
//  AmazfitWatch
//
//  Created by 李宪 on 2018/5/20.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

/**
 未成年人账号服务
 */
@protocol HMUnderageAccountServiceAPI <HMServiceAPI>

/**
 获取未成年账号的监护人批准状态
 */
- (id<HMCancelableAPI>)underageAccount_checkNeedCustodianApprovalWithCompletionBlock:(void (^)(BOOL success, NSString *message, BOOL needApproval, NSUInteger remainDays))completionBlock;

@end


@interface HMServiceAPI (UnderageAccount) <HMUnderageAccountServiceAPI>
@end
