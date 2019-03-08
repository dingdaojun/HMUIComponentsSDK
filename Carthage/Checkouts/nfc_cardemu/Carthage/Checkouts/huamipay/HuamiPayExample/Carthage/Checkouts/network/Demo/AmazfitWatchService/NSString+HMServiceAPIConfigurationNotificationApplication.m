//
//  NSString+HMServiceAPIConfigurationNotificationApplication.m
//  AmazfitWatchService
//
//  Created by 李宪 on 2018/5/17.
//  Copyright © 2018 lixian@huami.com. All rights reserved.
//

#import "NSString+HMServiceAPIConfigurationNotificationApplication.h"
#import "NSDictionary+HMSJSON.h"

@implementation NSString (HMServiceAPIConfigurationNotificationApplication)

- (NSString *)api_notificaitonApplicationBundleID {
    return [self componentsSeparatedByString:@"|"].firstObject;
}

- (NSString *)api_notificaitonApplicationTitle {
    NSArray *components = [self componentsSeparatedByString:@"|"];
    if (components.count != 2) {
        return nil;
    }

    return components[1];
}

@end
