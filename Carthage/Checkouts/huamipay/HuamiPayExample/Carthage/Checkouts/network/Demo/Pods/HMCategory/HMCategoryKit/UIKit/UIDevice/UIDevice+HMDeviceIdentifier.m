//
//  UIDevice+HMDeviceIdentifier.m
//  HMCategorySourceCodeExample
//
//  Created by 余彪 on 2017/5/15.
//  Copyright © 2017年 华米科技. All rights reserved.
//


#import "UIDevice+HMDeviceIdentifier.h"


static NSString *const HUAMI_DEVICEIDENTIFIER_KEY = @"HUAMI_DEVICEIDENTIFIER_KEY";


@implementation UIDevice (HMDeviceIdentifier)


#pragma mark 获取设备id
+ (NSString *)uniqueDeviceIdentifier {
    NSString *identifier = [[NSUserDefaults standardUserDefaults] stringForKey:HUAMI_DEVICEIDENTIFIER_KEY];
    
    if (!identifier) {
        identifier = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:HUAMI_DEVICEIDENTIFIER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return identifier;
}

@end
