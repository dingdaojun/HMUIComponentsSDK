//
//  HMServiceAPIConfigurationAgreement.h
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPI+Configuration.h"

@interface HMServiceAPIConfigurationAgreement : NSObject <HMServiceAPIConfigurationAgreement>

@property (assign, nonatomic) HMServiceAPIConfigurationAgreementType type;
@property (copy, nonatomic) NSString *countryCode;
@property (copy, nonatomic) NSString *version;
@property (assign, nonatomic) BOOL granted;

@end
