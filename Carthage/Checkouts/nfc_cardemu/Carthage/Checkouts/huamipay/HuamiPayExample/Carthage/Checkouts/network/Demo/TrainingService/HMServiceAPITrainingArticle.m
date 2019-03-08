//
//  HMServiceAPITrainingArticle.m
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingArticle.h"
#import <HMService/HMService.h>

@interface NSDictionary (HMServiceAPITrainingArticle) <HMServiceAPITrainingArticle>
@end

@implementation NSDictionary (HMServiceAPITrainingArticle)

- (NSString *)api_trainingArticleID {
    return self.hmjson[@"id"].string;
}

- (NSUInteger)api_trainingArticleOrder {
    return self.hmjson[@"sortOrder"].unsignedIntegerValue;
}

- (NSString *)api_trainingArticleTitle {
    return self.hmjson[@"title"].string;
}

- (NSString *)api_trainingArticleDescription {
    return self.hmjson[@"description"].string;
}

- (NSString *)api_trainingArticleURL {
    return self.hmjson[@"url"].string;
}

- (NSString *)api_trainingArticleImageURL {
    return self.hmjson[@"imgUrl"].string;
}

@end
