//
//  HMServiceAPIConfigurationAgreement.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIConfigurationAgreement.h"

@implementation HMServiceAPIConfigurationAgreement

#pragma mark - HMServiceAPIConfigurationAgreement

- (HMServiceAPIConfigurationAgreementType)api_configurationAgreementType {
    return self.type;
}

- (NSString *)api_configurationAgreementCountryCode {
    return self.countryCode;
}

- (NSString *)api_configurationAgreementVersion {
    return self.version;
}

- (BOOL)api_configurationAgreementGranted {
    return self.granted;
}

@end
