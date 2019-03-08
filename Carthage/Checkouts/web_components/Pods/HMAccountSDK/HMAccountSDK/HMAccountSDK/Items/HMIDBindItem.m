//
//  HMIDBindItem.m
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import "HMIDBindItem.h"

@interface HMIDBindItem ()

@property (nonatomic, copy, readwrite) HMIDBindType thirdType;

@property (nonatomic, copy, readwrite) NSString *thirdId;

@property (nonatomic, copy, readwrite) NSString *nickName;

@property (nonatomic, assign, readwrite) int64_t bindDate;

@end

@implementation HMIDBindItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.thirdId = dict[@"third_id"];
        self.thirdType = dict[@"third_type"];
        self.nickName = dict[@"nick_name"];
        self.bindDate = [dict[@"bond_date"] longLongValue];
    }
    return self;
}

@end
