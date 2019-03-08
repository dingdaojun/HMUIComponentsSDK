//
//  HMIDLoginItem.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDLoginItem.h"

@implementation HMIDLoginItem

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary{
    self = [super init];
    if (self) {
        self.appTokenItem = [[HMIDAppTokenItem alloc] initWithDictionary:[dictionary objectForKey:@"token_info"]];
        self.registItem = [[HMIDRegistItem alloc] initWithDictionary:[dictionary objectForKey:@"regist_info"]];
        self.userItem = [[HMIDUserItem alloc] initWithDictionary:[dictionary objectForKey:@"thirdparty_info"]];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"tokenInfo:%@\nregistInfo:%@\nuserInfo:%@",self.appTokenItem,self.registItem,self.userItem];
}

@end
