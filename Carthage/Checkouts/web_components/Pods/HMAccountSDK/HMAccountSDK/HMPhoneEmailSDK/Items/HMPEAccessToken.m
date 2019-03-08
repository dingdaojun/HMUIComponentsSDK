//
//  HMPEAccessToken.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/6.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMPEAccessToken.h"

@interface HMPEAccessToken ()

@property (nonatomic, copy) NSDictionary *dictionary;

@end

@implementation HMPEAccessToken

- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.accessToken = dictionary[@"access"];
        self.refreshToken = dictionary[@"refresh"];
        self.region = dictionary[@"region"];
        self.expiration = [dictionary[@"expiration"] doubleValue];
    }
    return self;
}

- (NSString *)description{
    return [self.dictionary description];
}

@end
