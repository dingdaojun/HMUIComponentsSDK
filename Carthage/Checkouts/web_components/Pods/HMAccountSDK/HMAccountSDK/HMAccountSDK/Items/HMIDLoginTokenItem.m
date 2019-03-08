//
//  HMIDLoginTokenItem.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDLoginTokenItem.h"
#import "HMAccountKeyChainStore.h"
#import "HMAccountTools.h"

/**登陆token*/
static NSString *const HMIDKeyChainLoginToken = @"MiDongSDKLoginToken";
/**登陆token有效时间*/
static NSString *const HMIDKeyChainLoginTokenTTL = @"MiDongSDKLoginTokenTTL";
/**登陆token过期时间*/
static NSString *const HMIDKeyChainLoginTokenExpiresIn = @"MiDongSDKLoginTokenExpiresIn";

@implementation HMIDLoginTokenItem

@synthesize loginToken = _loginToken;
@synthesize loginTokenTTL = _loginTokenTTL;
@synthesize loginTokenExpiresIn = _loginTokenExpiresIn;

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary{
    self = [super init];
    if (self) {
        _loginToken = [dictionary objectForKey:@"login_token"];
        NSInteger appttl = [[dictionary objectForKey:@"ttl"] integerValue];
        self.loginTokenTTL = appttl > 0 ? appttl : 0;
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)hasLogin{
    return ![HMAccountTools isEmptyString:self.loginToken] && self.loginTokenTTL > 0;
}

- (BOOL)save:(NSError *_Nullable *_Nullable)error{
    BOOL saveSuccess = [HMAccountKeyChainStore setPassword:self.loginToken forAccount:HMIDKeyChainLoginToken error:error];
    if (!saveSuccess) {
        return NO;
    }
    saveSuccess = [HMAccountKeyChainStore setPassword:[NSString stringWithFormat:@"%ld",(long)self.loginTokenTTL] forAccount:HMIDKeyChainLoginTokenTTL error:error];
    if (!saveSuccess) {
        return NO;
    }
    
    saveSuccess = [HMAccountKeyChainStore setPassword:[NSString stringWithFormat:@"%ld",(long)self.loginTokenExpiresIn] forAccount:HMIDKeyChainLoginTokenExpiresIn error:error];
    if (!saveSuccess) {
        return NO;
    }
    return YES;
}

- (BOOL)isValided{
    NSTimeInterval loginDiffTime = self.loginTokenExpiresIn - [[NSDate date] timeIntervalSince1970];
    BOOL earlierThanCreateTime = loginDiffTime >= self.loginTokenTTL;
    BOOL laterThanExpireTime = loginDiffTime <= self.loginTokenTTL/4.0;
    return !earlierThanCreateTime && !laterThanExpireTime;
}

- (void)clear{
    _loginToken = nil;
    self.loginTokenTTL = 0;
    _loginTokenExpiresIn = 0;
    [HMAccountKeyChainStore deletePasswordForAccount:HMIDKeyChainLoginToken error:nil];
    [HMAccountKeyChainStore deletePasswordForAccount:HMIDKeyChainLoginTokenTTL error:nil];
    [HMAccountKeyChainStore deletePasswordForAccount:HMIDKeyChainLoginTokenExpiresIn error:nil];
}

- (void)copyFromItem:(HMIDLoginTokenItem * _Nonnull)item{
    _loginToken = item.loginToken;
    _loginTokenTTL = item.loginTokenTTL;
    _loginTokenExpiresIn = item.loginTokenExpiresIn;
}

#pragma mark - Getter and Setter

- (NSString *)loginToken{
    if (!_loginToken) {
        NSError *error = nil;
        _loginToken = [HMAccountKeyChainStore passwordForAccount:HMIDKeyChainLoginToken error:&error];
        if (error) {
            NSLog(@"get loginToken Error:%@",error);
        }
    }
    return _loginToken;
}

- (NSInteger)loginTokenTTL{
    if (_loginTokenTTL <= 0) {
        NSError *error = nil;
        _loginTokenTTL = [[HMAccountKeyChainStore passwordForAccount:HMIDKeyChainLoginTokenTTL error:&error] integerValue];
        if (error) {
            NSLog(@"get loginTokenTTL Error:%@",error);
        }
    }
    return _loginTokenTTL;
}

- (void)setLoginTokenTTL:(NSInteger)loginTokenTTL{
    _loginTokenTTL = loginTokenTTL;
    if (_loginTokenTTL > 0) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        _loginTokenExpiresIn = _loginTokenTTL + currentTime;
    }
}

- (NSInteger)loginTokenExpiresIn{
    if (_loginTokenExpiresIn <= 0) {
        NSError *error = nil;
        _loginTokenExpiresIn = [[HMAccountKeyChainStore passwordForAccount:HMIDKeyChainLoginTokenExpiresIn error:&error] integerValue];
        if (error) {
            NSLog(@"get loginTokenExpiresIn Error:%@",error);
        }
    }
    return _loginTokenExpiresIn;
}

@end
