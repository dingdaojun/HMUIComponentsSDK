//  HMServiceAPI+PrivacyAgreement.h
//  Created on 2018/5/18
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>


@protocol HMServiceAPIPrivacyAgreementVersion <NSObject>

@property (readonly) NSString *api_privacyAgreementLanguage;
@property (readonly) NSString *api_privacyAgreementVersion;

@end



@protocol HMServicePrivacyAgreementAPI <HMServiceAPI>

- (id<HMCancelableAPI>)privacyAgreement_retrieveWithType:(NSString *)type
                                             countryCode:(NSString *)countryCode
                                                  isAuth:(BOOL)isAuth
                                         completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIPrivacyAgreementVersion>> *privacyAgreements))completionBlock;

@end

@interface HMServiceAPI (PrivacyAgreement) <HMServicePrivacyAgreementAPI>
@end
