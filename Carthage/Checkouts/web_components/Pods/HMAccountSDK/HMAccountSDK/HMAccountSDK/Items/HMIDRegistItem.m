//
//  HMIDRegistItem.m
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRegistItem.h"

@implementation HMIDRegistItem

@synthesize newUser = _newUser;
@synthesize registDate = _registDate;
@synthesize region = _region;

- (nonnull instancetype)initWithDictionary:(NSDictionary * _Nonnull )dictionary{
    self = [super init];
    if (self) {
        NSInteger isNewUser = [[dictionary objectForKey:@"is_new_user"] integerValue];
        _newUser = isNewUser == 1 ? YES : NO;
        _registDate = [dictionary objectForKey:@"regist_date"];
        _region = [[dictionary objectForKey:@"region"] integerValue];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"\nnewUser:%@\n registDate:%@\n region:%ld\n",self.newUser?@"YES":@"NO",self.registDate,(long)self.region];
}

@end
