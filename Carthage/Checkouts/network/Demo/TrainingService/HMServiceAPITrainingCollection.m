//
//  HMServiceAPITrainingCollection.m
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingCollection.h"
#import <HMService/HMService.h>
#import "HMServiceAPITrainingData.h"

@interface NSDictionary (HMServiceAPITrainingCollection) <HMServiceAPITrainingCollection>
@end

@implementation NSDictionary (HMServiceAPITrainingCollection)

- (NSString *)api_trainingCollectionID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingCollectionName {
    return self.hmjson[@"name"].string;
}

- (NSArray<id<HMServiceAPITrainingData>> *)api_trainingCollectionTrainings {
    return self.hmjson[@"trainings"].array;
}

@end

