//
//  HMIDUserItem.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDUserItem.h"
#import "HMAccountTools.h"

@implementation HMIDUserItem

@synthesize nickname = _nickname;
@synthesize avatarURL = _avatarURL;
@synthesize largeAvatarURL = _largeAvatarURL;
@synthesize thirdId = _thirdId;

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary{
    self = [super init];
    if (self) {
        //用URLEncoder.encode(nickname,"utf-8"))进行了处理,需要用URLDecoder进行反向处理
        NSString *nickName = [dictionary objectForKey:@"nickname"];
        if (![HMAccountTools isEmptyString:nickName]) {
            _nickname = [nickName stringByRemovingPercentEncoding];
        }
        _avatarURL = [dictionary objectForKey:@"icon"];
        _largeAvatarURL = [dictionary objectForKey:@"large_icon"];
        _thirdId = [dictionary objectForKey:@"third_id"];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\nnickname:%@\navatarURL:%@\nlargeAvatarURL:%@\nthirdId:%@\n",self.nickname,self.avatarURL,self.largeAvatarURL,self.thirdId];
}

@end
