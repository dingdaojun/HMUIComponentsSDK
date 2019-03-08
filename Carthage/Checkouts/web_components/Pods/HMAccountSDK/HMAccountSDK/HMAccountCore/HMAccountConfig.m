//
//  HMAccountConfig.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMAccountConfig.h"
#import <UIKit/UIKit.h>

static HMIDServerEnvironment currentServerEnvironment = HMIDServerEnvironmentTest;

struct EnvConfig{
    char IDCNApiRequestHost[128];
    char IDUSApiRequestHost[128];
    char IDApiRequestHost[128];
    char PEApiRequestHost[128];
};

static struct EnvConfig envConfigArray[HMIDServerEnvironmentCount] = {
    //API Dev
    {
        .IDCNApiRequestHost          = "https://account-cn-staging.huami.com",
        .IDUSApiRequestHost          = "https://account-us-staging.huami.com",
        .IDApiRequestHost            = "https://account-staging.huami.com",
        .PEApiRequestHost            = "https://api-user-staging.huami.com",
    },
    //API Live
    {
        .IDCNApiRequestHost          = "https://account-cn.huami.com",
        .IDUSApiRequestHost          = "https://account-us.huami.com",
        .IDApiRequestHost            = "https://account.huami.com",
        .PEApiRequestHost            = "https://api-user.huami.com",
    }
};

static const struct EnvConfig* getEnvConfig() {
    return &envConfigArray[currentServerEnvironment];
}

@implementation HMAccountConfig

#pragma mark - Public Methods

+ (NSDictionary *)customHeader {
    return [[NSDictionary alloc] initWithDictionary:p_customHeader()];
}

+ (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (!value || !field) {
        return;
    }
    if ([field isEqualToString:@"Content-Type"] ||
        [field isEqualToString:@"User-Agent"] ||
        [field isEqualToString:@"Accept-Language"] ||
        [field isEqualToString:@"app_name"]
        ) {
        return;
    }
    [p_customHeader() setObject:value forKey:field];
}


+ (void)setServerEnvironment:(HMIDServerEnvironment)serverEnvironment{
    currentServerEnvironment = serverEnvironment;
}

+ (HMIDServerEnvironment)getCurrentServerEnvironment{
    return currentServerEnvironment;
}

+ (NSString *)idAccountServerHost{
    return [NSString stringWithUTF8String:getEnvConfig()->IDApiRequestHost];
}

+ (NSString *)idAccountCNServerHost{
    return [NSString stringWithUTF8String:getEnvConfig()->IDCNApiRequestHost];
}

+ (NSString *)idAccountUSServerHost{
    return [NSString stringWithUTF8String:getEnvConfig()->IDUSApiRequestHost];
}

+ (NSString *)phoneEmailAccountServerHost{
    return [NSString stringWithUTF8String:getEnvConfig()->PEApiRequestHost];
}

#pragma mark - Private

static NSMutableDictionary *p_customHeader() {
    static NSMutableDictionary *_customHeader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _customHeader = [[NSMutableDictionary alloc] init];
    });
    return _customHeader;
}
@end
