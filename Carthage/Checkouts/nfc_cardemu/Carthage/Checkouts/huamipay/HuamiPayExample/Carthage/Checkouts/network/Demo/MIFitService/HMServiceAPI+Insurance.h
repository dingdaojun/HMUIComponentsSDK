//
//  HMServiceAPI+Insurance.h
//  HMNetworkLayer
//
//  Created by 李宪 on 21/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

// 跑步险保单
@protocol HMServiceAPIRunInsurancePolicy <NSObject>

@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyCampaignID;               // 营销活动ID
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyProductPackageID;         // 产品组合ID
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyBuyURL;                   // 购买地址
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyChannelOrderNumber;       // 渠道流水号
@property (nonatomic, strong, readonly) NSDate *api_runInsurancePolicyJoinDate;                 // 投保日期
@property (nonatomic, strong, readonly) NSDate *api_runInsurancePolicyBecomeEffectiveDate;      // 保单生效日期
@property (nonatomic, strong, readonly) NSDate *api_runInsurancePolicyLoseEffectiveDate;        // 保单失效日期
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyNumber;                   // 保单号
@property (nonatomic, assign, readonly) double api_runInsurancePolicyCoverage;                  // 保额
@property (nonatomic, assign, readonly) double api_runInsurancePolicyPremium;                   // 保费
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyClientCredentialNumber;   // 被保人证件号码
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyClientCredentialType;     // 被保人证件类型
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyClientPhone;              // 联系电话
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyClientName;               // 被保人姓名
@property (nonatomic, copy, readonly) NSString *api_runInsurancePolicyClientXiaomiID;           // 小米ID

@end


@protocol HMServiceInsuranceAPI <HMServiceAPI>

/**
 跑步险
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=209
 */
- (id<HMCancelableAPI>)insurance_runInsurancePolicysWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIRunInsurancePolicy>> *insurancePolicys))completionBlock;

@end

@interface HMServiceAPI (Insurance) <HMServiceInsuranceAPI>
@end
