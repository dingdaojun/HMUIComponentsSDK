//
//  HMServiceAPI+Agreement.h
//  AmazfitWatch
//
//  Created by 李宪 on 2018/5/12.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

/**
 用户协议类型

 - HMServiceAPIAgreementTypeUsage: 使用协议
 - HMServiceAPIAgreementTypePrivacy: 隐私协议
 - HMServiceAPIAgreementTypeImprovement: 改善计划协议
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIAgreementType) {
    HMServiceAPIAgreementTypeUsage,
    HMServiceAPIAgreementTypePrivacy,
    HMServiceAPIAgreementTypeImprovement,
};


@protocol HMServiceAPIAgreement <NSObject>

@property (readonly) HMServiceAPIAgreementType api_agreementType;
@property (readonly) NSString *api_agreementCountryCode;
@property (readonly) NSString *api_agreementVersion;

@end

@protocol HMAgreementServiceAPI <HMServiceAPI>

/**
 获取最新的协议内容
 */
- (id<HMCancelableAPI>)agreement_retrieveWithType:(HMServiceAPIAgreementType)type
                                  completionBlock:(void (^)(BOOL success, NSString *message, NSArray <id<HMServiceAPIAgreement>> * agreements))completionBlock;

@end


@interface HMServiceAPI (Agreement) <HMAgreementServiceAPI>
@end
