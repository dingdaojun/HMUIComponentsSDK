//
//  HMIDAppTokenItem.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDAppTokenItem.h"
#import "HMAccountTools.h"

@interface HMIDAppTokenItem ()
/**
 主key
 */
@property (nonnull, nonatomic, copy) NSString *bundleIdentifier;

@end

@implementation HMIDAppTokenItem

@synthesize appToken = _appToken;
@synthesize appTokenTTL = _appTokenTTL;
@synthesize appTokenExpiresIn = _appTokenExpiresIn;
@synthesize userId = _userId;

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull)dictionary{
    self = [super init];
    if (self) {
        _appToken = [dictionary objectForKey:@"app_token"];
        NSInteger appttl = [[dictionary objectForKey:@"app_ttl"] integerValue];
        self.appTokenTTL = appttl > 0 ? appttl : 0;
        _userId = [dictionary objectForKey:@"user_id"];
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)hasLogin{
    return ![HMAccountTools isEmptyString:self.userId] && ![HMAccountTools isEmptyString:self.appToken] && self.appTokenTTL > 0;
}

- (BOOL)save{
    if (!self.userId || !self.appToken) {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:[self userIdKey]];
    [[NSUserDefaults standardUserDefaults] setObject:self.appToken forKey:[self appTokenKey]];
    [[NSUserDefaults standardUserDefaults] setInteger:self.appTokenTTL forKey:[self appTokenTTLKey]];
    [[NSUserDefaults standardUserDefaults] setInteger:self.appTokenExpiresIn forKey:[self appTokenExpiresInKey]];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isValided{
    NSTimeInterval appDiffTime = self.appTokenExpiresIn - [[NSDate date] timeIntervalSince1970];
    BOOL earlierThanCreateTime = appDiffTime >= self.appTokenTTL;
    BOOL laterThanExpireTime = appDiffTime <= self.appTokenTTL/4.0;
    return !earlierThanCreateTime && !laterThanExpireTime;
}

- (void)clear{
    _appToken = nil;
    _appTokenExpiresIn = 0;
    self.appTokenTTL = 0;
    _userId = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self userIdKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self appTokenKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self appTokenTTLKey]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self appTokenExpiresInKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)copyFromItem:( HMIDAppTokenItem * _Nonnull )item{
    _appToken = item.appToken;
    _appTokenExpiresIn = item.appTokenExpiresIn;
    self.appTokenTTL = item.appTokenTTL;
    if (item.userId && item.userId > 0) {
        _userId = item.userId;
    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\nuserId:%@\napptoken:%@\nttl:%ld\nexpiresIn:%@\n",self.userId,self.appToken,(long)self.appTokenTTL,[NSDate dateWithTimeIntervalSince1970:self.appTokenExpiresIn]];
}

#pragma mark - Getter and Setter

- (NSString *)userId{
    if (!_userId) {
        _userId = [[NSUserDefaults standardUserDefaults] objectForKey:[self userIdKey]];
    }
    return _userId;
}

- (NSString *)appToken{
    if (!_appToken) {
        _appToken = [[NSUserDefaults standardUserDefaults] objectForKey:[self appTokenKey]];
    }
    return _appToken;
}

- (NSInteger)appTokenTTL{
    if (_appTokenTTL <= 0) {
        _appTokenTTL = [[NSUserDefaults standardUserDefaults] integerForKey:[self appTokenTTLKey]];
    }
    return _appTokenTTL;
}

- (void)setAppTokenTTL:(NSInteger)appTokenTTL{
    _appTokenTTL = appTokenTTL;
    if (appTokenTTL > 0) {
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        _appTokenExpiresIn = appTokenTTL + currentTime;
    }
}

- (NSInteger)appTokenExpiresIn{
    if (_appTokenExpiresIn <= 0) {
        _appTokenExpiresIn = [[NSUserDefaults standardUserDefaults] integerForKey:[self appTokenExpiresInKey]];
    }
    return _appTokenExpiresIn;
}

#pragma mark - local save key

- (NSString *)bundleIdentifier{
    if (!_bundleIdentifier) {
        _bundleIdentifier = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    }
    return _bundleIdentifier;
}

- (NSString *)userIdKey{
    return [self.bundleIdentifier stringByAppendingString:@"userId"];
}

- (NSString *)appTokenKey{
    return [self.bundleIdentifier stringByAppendingString:@"AppToken"];
}

- (NSString *)appTokenTTLKey{
    return [self.bundleIdentifier stringByAppendingString:@"AppTokenTTL"];
}

- (NSString *)appTokenExpiresInKey{
    return [self.bundleIdentifier stringByAppendingString:@"AppTokenExpiresIn"];
}

@end
