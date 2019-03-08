//
//  NSDictionary+HMServiceAPIConfigurationWatchFace.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSDictionary+HMSJSON.h"


@implementation NSDictionary (HMServiceAPIConfigurationWatchFace)

- (NSString *)api_watchFacePackageName {
    return self.hmjson[@"pkgName"].string;
}

- (NSString *)api_watchFaceServiceName {
    return self.hmjson[@"serviceName"].string;
}

@end
