//
//  NSDictionary+HMServiceAPIIntervalRun.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSDictionary+HMServiceAPIIntervalRun.h"
#import "NSDictionary+HMSJSON.h"


@implementation NSDictionary (HMServiceAPIConfigurationIntervalRunItem)

- (NSInteger)api_configurationIntervalRunItemID {
    return self.hmjson[@"id"].integerValue;
}

- (HMServiceAPIConfigurationIntervalRunLengthType)api_configurationIntervalRunLengthType {
    return self.hmjson[@"lengthType"].integerValue;
}

- (NSInteger)api_configurationIntervalRunLengthValue {
    return self.hmjson[@"lengthValue"].integerValue;
}

- (HMServiceAPIConfigurationIntervalRunReminderType)api_configurationIntervalRunReminderType {
    return self.hmjson[@"reminderType"].integerValue;
}

- (NSArray <NSNumber *>*)api_configurationIntervalRunReminderValue {
    return self.hmjson[@"reminderValue"].array;
}

@end

@interface NSDictionary (HMServiceAPIConfigurationIntervalRunGroup) <HMServiceAPIConfigurationIntervalRunGroup>
@end

@implementation NSDictionary (HMServiceAPIConfigurationIntervalRunGroup)

- (NSInteger)api_configurationIntervalRunGroupID {
    return self.hmjson[@"groupId"].integerValue;
}

- (NSUInteger)api_configurationIntervalRunRepeatCount {
    return self.hmjson[@"repeatCount"].unsignedIntegerValue;
}

- (NSArray<id<HMServiceAPIConfigurationIntervalRunItem>> *)api_configurationIntervalRunItems {
    return self.hmjson[@"itemInfoList"].array;
}

@end



@implementation NSDictionary (HMServiceAPIConfigurationIntervalRun)

- (NSInteger)api_configurationIntervalRunID {
    return self.hmjson[@"id"].integerValue;
}

- (NSString *)api_configurationIntervalRunTitle {
    return self.hmjson[@"title"].string;
}

//- (HMServiceAPIConfigurationIntervalRunDeviceType)api_configurationIntervalRunDeviceType {
//    NSString *modelName = self.hmjson[@"modelName"].string;
//    if (modelName.length == 0 || [@"everest" isEqualToString:modelName]) {
//        return HMServiceAPIConfigurationIntervalRunDeviceTypeEverest;
//    } else if ([@"huanghe" isEqualToString:modelName]) {
//        return HMServiceAPIConfigurationIntervalRunDeviceTypeHuanghe;
//    } else {
//        return HMServiceAPIConfigurationIntervalRunDeviceTypeEverest;
//    }
//
//}

- (NSArray<id<HMServiceAPIConfigurationIntervalRunGroup>> *)api_configurationIntervalRunGroupList {
    return self.hmjson[@"groupList"].array;
}

@end
