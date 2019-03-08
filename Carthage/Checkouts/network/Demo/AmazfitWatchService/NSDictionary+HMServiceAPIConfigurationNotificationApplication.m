//
//  NSDictionary+HMServiceAPIConfigurationNotificationApplication.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSDictionary+HMServiceAPIConfigurationNotificationApplication.h"
#import "NSDictionary+HMSJSON.h"

@implementation NSDictionary (HMServiceAPIConfigurationNotificationApplication)

- (NSString *)api_notificaitonApplicationBundleID {
    return self.hmjson[@"pkgName"].string;
}

- (NSString *)api_notificaitonApplicationTitle {
    return self.hmjson[@"appName"].string;
}

@end
