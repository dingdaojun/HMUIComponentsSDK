//
//  HMServiceAPITrainingBanner.m
//  HMNetworkLayer
//
//  Created by 李宪 on 23/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingBanner.h"
#import <HMService/HMService.h>

@implementation NSString (HMServiceAPITrainingBannerType)

- (HMServiceAPITrainingBannerType)hms_trainingBannerType {
    if ([self isEqualToString:@"TRAINING_COLLECTION"]) {
        return HMServiceAPITrainingBannerTypeTrainingCollection;
    }
    
    if ([self isEqualToString:@"SINGLE_TRAINING"]) {
        return HMServiceAPITrainingBannerTypeSingleTraining;
    }
    
    return HMServiceAPITrainingBannerTypeArticle;
}

@end


@interface NSDictionary (HMServiceAPITrainingBanner) <HMServiceAPITrainingBanner>
@end

@implementation NSDictionary (HMServiceAPITrainingBanner)

- (NSString *)api_trainingBannerID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingBannerName {
    return self.hmjson[@"name"].string;
}

- (NSString *)api_trainingBannerImageURL {
    return self.hmjson[@"bannerIllustrated"].string;
}

- (HMServiceAPITrainingBannerType)api_trainingBannerType {
    return [self.hmjson[@"type"].string hms_trainingBannerType];
}

- (NSString *)api_trainingBannerTrainingCollectionID {
    if (self.api_trainingBannerType != HMServiceAPITrainingBannerTypeTrainingCollection) {
        return nil;
    }
    
    return self.hmjson[@"training"][@"id"].string;
}

- (NSString *)api_trainingBannerTrainingCollectionName {
    if (self.api_trainingBannerType != HMServiceAPITrainingBannerTypeTrainingCollection) {
        return nil;
    }
    
    return self.hmjson[@"training"][@"name"].string;
}

- (NSString *)api_trainingBannerSingleTrainingID {
    if (self.api_trainingBannerType != HMServiceAPITrainingBannerTypeSingleTraining) {
        return nil;
    }
    
    return self.hmjson[@"training"][@"id"].string;
}

- (NSString *)api_trainingBannerSingleTrainingName {
    if (self.api_trainingBannerType != HMServiceAPITrainingBannerTypeSingleTraining) {
        return nil;
    }
    
    return self.hmjson[@"training"][@"name"].string;
}

- (NSString *)api_trainingBannerArticleURL {
    if (self.api_trainingBannerType != HMServiceAPITrainingBannerTypeArticle) {
        return nil;
    }
    
    return self.hmjson[@"articleUrl"].string;
}

@end
