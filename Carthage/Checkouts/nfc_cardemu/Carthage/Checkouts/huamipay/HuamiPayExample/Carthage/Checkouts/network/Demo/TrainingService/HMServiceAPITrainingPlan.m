//
//  HMServiceAPITrainingPlan.m
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingPlan.h"
#import <HMService/HMService.h>


@interface NSDictionary (HMServiceAPITrainingPlanDayItem) <HMServiceAPITrainingPlanDayItem>
@end

@implementation NSDictionary (HMServiceAPITrainingPlanDayItem)

- (NSUInteger)api_trainingPlanDayItemIndex {
    return self.hmjson[@"dayIndex"].unsignedIntegerValue;
}

- (BOOL)api_trainingPlanDayItemFinished {
    return self.hmjson[@"isFinished"].boolean;
}

- (NSString *)api_trainingPlanDayItemTrainingID {
    return self.hmjson[@"trainingId"].string;
}

- (NSString *)api_trainingPlanDayItemTrainingName {
    return self.hmjson[@"name"].string;
}

- (NSTimeInterval)api_trainingPlanDayItemDuration {
    return self.hmjson[@"time"].doubleValue / 1000.f;
}

- (double)api_trainingPlanDayItemPlanEnergyBurnedInCalorie {
    return self.hmjson[@"consumption"].doubleValue * 1000.f;
}

- (id<HMServiceAPITrainingData>)api_trainingPlanDayItemTrainingData {
    return (id<HMServiceAPITrainingData>)self.hmjson[@"detail"].dictionary;
}

- (NSString *)api_trainingPlanDayItemArticleTitle {
    return self.hmjson[@"articleTitle"].string;
}

- (NSString *)api_trainingPlanDayItemArticleURL {
    return self.hmjson[@"articleLink"].string;
}

- (NSString *)api_trainingPlanDayItemArticleImageURL {
    return self.hmjson[@"articleImgUrl"].string;
}

@end


@interface NSDictionary (HMServiceAPITrainingPlan) <HMServiceAPITrainingPlan>
@end

@implementation NSDictionary (HMServiceAPITrainingPlan)

- (NSString *)api_trainingPlanID {
    return self.hmjson[@"trainingPlanId"].string;
}

- (NSString *)api_trainingPlanName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingPlanIntroduction {
    return self.hmjson[@"introduction"].string;
}

- (NSString *)api_trainingPlanDetailURL {
    return self.hmjson[@"detailsPageIllustrated"].string;
}

- (double)api_trainingPlanEnergyBurnedInCalorie {
    return self.hmjson[@"consumption"].doubleValue * 1000.f;
}

- (HMServiceAPITrainingDifficulty)api_trainingPlanDifficulty {
    return self.hmjson[@"difficultyDegree"].unsignedIntegerValue;
}

- (NSDate *)api_trainingPlanDate {
    return [self.hmjson[@"startDay"] dateWithFormat:@"yyyy-MM-dd"];
}

- (NSUInteger)api_trainingPlanTotalDays {
    return self.hmjson[@"totalDays"].unsignedIntegerValue;
}

- (NSUInteger)api_trainingPlanTrainingDays {
    return self.hmjson[@"trainingDays"].unsignedIntegerValue;
}

- (NSTimeInterval)api_trainingPlanDuration {
    return self.hmjson[@"time"].doubleValue / 1000.f;
}

- (NSArray<id<HMServiceAPITrainingPlanDayItem>> *)api_trainingPlanDayItems {
    return self.hmjson[@"dayTrainingItems"].array;
}

@end


