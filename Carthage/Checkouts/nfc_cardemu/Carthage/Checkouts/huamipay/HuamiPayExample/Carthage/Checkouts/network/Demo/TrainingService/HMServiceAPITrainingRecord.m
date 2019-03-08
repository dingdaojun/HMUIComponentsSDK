//
//  HMServiceAPITrainingRecord.m
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingRecord.h"
#import <HMService/HMService.h>
#import "HMServiceAPITrainingTypeDefine.h"
#import "HMServiceAPITrainingData.h"
#import <objc/runtime.h>


@interface NSDictionary (HMServiceAPITrainingRecordHeartRate) <HMServiceAPITrainingRecordHeartRate>
@end

@implementation NSDictionary (HMServiceAPITrainingRecordHeartRate)

- (NSDate *)api_trainingRecordHeartRateTime {
    return self.hmjson[@"t"].date;
}

- (NSUInteger)api_trainingRecordHeartRateValue {
    return self.hmjson[@"v"].unsignedIntegerValue;
}

@end


@interface NSDictionary (HMServiceAPITrainingRecord) <HMServiceAPITrainingRecord>
@end

@implementation NSDictionary (HMServiceAPITrainingRecord)

- (NSDictionary *)api_trainingRecordHeartRateDictionary {
    NSDictionary *heartRateDictionary = objc_getAssociatedObject(self, "api_trainingRecordHeartRateData");
    if (!heartRateDictionary) {
        heartRateDictionary = self.hmjson[@"heartRateData"].dictionary;
        if (!heartRateDictionary) {
            return nil;
        }
        
        objc_setAssociatedObject(self, "api_trainingRecordHeartRateData", heartRateDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return heartRateDictionary;
}

- (NSString *)api_trainingRecordID {
    return self.hmjson[@"createTime"].string;
}

- (NSDate *)api_trainingRecordBeginTime {
    
    if (self.api_trainingRecordHeartRateDictionary) {
        return self.api_trainingRecordHeartRateDictionary.hmjson[@"startTime"].date;
    }
    
    return self.hmjson[@"startTime"].date;
}

- (NSDate *)api_trainingRecordEndTime {
    return self.hmjson[@"endTime"].date;
}

- (NSUInteger)api_trainingRecordFinishTrainingTime {
    return self.hmjson[@"finishNumber"].unsignedIntegerValue;
}

- (NSTimeInterval)api_trainingRecordSpendTime {
    
    NSTimeInterval spendTime = self.hmjson[@"duration"].doubleValue;
    if (spendTime > 0) {
        return spendTime;
    }
    
    NSDictionary *dictionary = self.hmjson[@"time"].dictionary;
    HMServiceAPITrainingUserGender gender = self.api_cachedTrainingUserGender;
    if (gender == HMServiceAPITrainingUserGenderMale) {
        return dictionary.hmjson[@"male"].doubleValue / 1000.f;
    }
    else {
        return dictionary.hmjson[@"female"].doubleValue / 1000.f;
    }
}

- (double)api_trainingRecordEnergyBurnedInCalorie {
    return self.hmjson[@"consumption"].doubleValue * 1000.f;
}

- (NSString *)api_trainingRecordTrainingID {
    return self.hmjson[@"trainingId"].string;
}

- (NSString *)api_trainingRecordTrainingName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingRecordTrainingPlanID {
    return self.hmjson[@"trainingPlanId"].string;
}

- (NSString *)api_trainingRecordDetailImageURL {
    return self.hmjson[@"detailImgUrl"].string;
}

- (NSArray<id<HMServiceAPITrainingRecordHeartRate>> *)api_trainingRecordHeartRates {
    
    NSDictionary *heartRateDictionary = self.api_trainingRecordHeartRateDictionary;
    if (!heartRateDictionary) {
        return nil;
    }
    
    NSTimeInterval startTimestamp = heartRateDictionary.hmjson[@"startTime"].date.timeIntervalSince1970;
    NSUInteger startValue = 0;
    NSMutableArray *heartRates = [NSMutableArray new];
    
    NSArray *rawHeartRates = [heartRateDictionary.hmjson[@"heartRate"].string componentsSeparatedByString:@";"];
    for (NSString *sample in rawHeartRates) {
        if (![sample isKindOfClass:[NSString class]]) {
            continue;
        }
        
        NSArray *pair = [sample componentsSeparatedByString:@","];
        if (pair.count != 2) {
            continue;
        }
        
        NSTimeInterval time = [pair.firstObject doubleValue] + startTimestamp;
        startTimestamp = time;
        
        NSUInteger value = [pair.lastObject integerValue] + startValue;
        startValue = value;
        
        [heartRates addObject:@{@"t" : @(time),
                                @"v" : @(value)}];
    }
    
    return heartRates;
}

- (NSArray<id<HMServiceAPITrainingAction>> *)api_trainingRecordActions {
    return self.hmjson[@"actions"].array;
}


@end
