//
//  HMServiceAPITrainingMiDongQuan.m
//  HMNetworkLayer
//
//  Created by 李宪 on 25/5/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPITrainingMiDongQuan.h"
#import <HMService/HMService.h>

@interface NSDictionary (HMServiceAPITrainingMiDongQuan) <HMServiceAPITrainingMiDongQuan>
@end

@implementation NSDictionary (HMServiceAPITrainingMiDongQuan)

- (NSString *)api_trainingMiDongQuanID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_trainingMiDongQuanImageURL {
    return self.hmjson[@"picture"].string;
}

- (NSString *)api_trainingMiDongQuanDetailURL {
    return self.hmjson[@"postDetailUrl"].string;
}

- (NSString *)api_trainingMiDongQuanUserID {
    return self.hmjson[@"userId"].string;
}

- (NSString *)api_trainingMiDongQuanUserNickname {
    return self.hmjson[@"nickName"].string;
}

- (NSString *)api_trainingMiDongQuanUserAvatar {
    return self.hmjson[@"portrait"].string;
}

- (NSString *)api_trainingMiDongQuanUserProfileURL {
    return self.hmjson[@"userProfileUrl"].string;
}

@end
