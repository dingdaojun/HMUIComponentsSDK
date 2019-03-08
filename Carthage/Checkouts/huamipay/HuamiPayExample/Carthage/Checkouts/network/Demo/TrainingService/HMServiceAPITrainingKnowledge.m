//
//  HMServiceAPITrainingKnowledge.m
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingKnowledge.h"
#import <HMService/HMService.h>

@interface NSDictionary (HMServiceAPITrainingKnowledge) <HMServiceAPITrainingKnowledge>
@end

@implementation NSDictionary (HMServiceAPITrainingKnowledge)

- (NSString *)api_trainingKnowledgeID {
    return self.hmjson[@"id"].string;
}

- (NSUInteger)api_trainingKnowledgeOrder {
    return self.hmjson[@"sortOrder"].unsignedIntegerValue;
}

- (NSString *)api_trainingKnowledgeTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_trainingKnowledgeDescription {
    return self.hmjson[@"description"].string;
}

- (NSString *)api_trainingKnowledgeURL {
    return self.hmjson[@"url"].string;
}

- (NSString *)api_trainingKnowledgeImageURL {
    return self.hmjson[@"imgUrl"].string;
}

@end
