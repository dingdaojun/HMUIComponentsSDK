//
//  HMPEConfig.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/20.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEConfig.h"
#import "HMAccountTools.h"
#import "HMAccountKeyChainStore.h"

@interface HMPEConfig ()

@property (nonnull, nonatomic, copy, readwrite) NSString *r;

@property (nonnull, nonatomic, copy, readwrite) NSString *clientId;

@property (nonnull, nonatomic, copy, readwrite) NSString *appName;

@end

@implementation HMPEConfig

+ (nonnull HMPEConfig *)sharedInstance{
    static HMPEConfig *_instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.clientId = @"HuaMi";
        self.deviceId = [HMAccountKeyChainStore uniqueDeviceIdentifier];
        self.redirectURI = @"https://s3-us-west-2.amazonaws.com/hm-registration/successsignin.html";
    }
    return self;
}

- (void)setDeviceId:(NSString *)deviceId{
    _deviceId = deviceId;
    if ([deviceId length] && deviceId) {
        self.r = [HMAccountTools md5HexDigestWithOriginString:deviceId digestLength:32];
    }
}

- (NSString *)appName{
    if (!_appName) {
        NSArray *urlTypesArray = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
        NSArray *urlSchemes;
        for (NSDictionary *dict in urlTypesArray) {
            if ([[dict objectForKey:@"CFBundleURLName"] isEqualToString:@"HMAccount"]) {
                urlSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
                break;
            }
        }
        if ([urlSchemes count] == 0) {
            NSAssert(NO, @"请在info.plist中添加CFBundleURLTypes并配置在米动账号系统中申请的AppName(CFBundleURLName must be v)e.g.<dict><key>CFBundleTypeRole</key><string>HM</string> <key>CFBundleURLName</key> <string>HMAccount</string> <key>CFBundleURLSchemes</key> <array> <string>appname</string> </array> </dict>");
        }
        _appName = [urlSchemes firstObject];
    }
    return _appName;
}

@end
