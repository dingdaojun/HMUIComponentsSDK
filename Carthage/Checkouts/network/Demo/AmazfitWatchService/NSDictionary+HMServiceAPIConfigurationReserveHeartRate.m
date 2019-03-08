//
//  NSDictionary+HMServiceAPIConfigurationReserveHeartRate.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSDictionary+HMServiceAPIConfigurationReserveHeartRate.h"
#import "NSDictionary+HMSJSON.h"
#import "HMServiceAPI+Configuration.h"


@implementation NSDictionary (HMServiceAPIConfigurationReserveHeartRate)

- (HMServiceAPIConfigurationReserveHeartRateType)api_configurationReserveHeartRateType {
    return self.hmjson[@"heartRateType"].unsignedIntegerValue;
}

- (NSInteger)api_configurationReserveHeartRateRestingHeartRate {
    return self.hmjson[@"restingHeartRate"].unsignedIntegerValue;
}

- (NSArray<NSNumber *> *)api_configurationReserveHeartRateSection {
    return self.hmjson[@"section"].array;
}

- (NSArray<NSNumber *> *)api_configurationReserveHeartRatePercent {
    return self.hmjson[@"percent"].array;
}

@end
