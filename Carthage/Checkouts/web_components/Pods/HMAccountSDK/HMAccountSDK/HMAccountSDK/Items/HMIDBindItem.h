//
//  HMIDBindItem.h
//  HMAccountSDKCodeDemo
//
//  Created by 李林刚 on 2017/4/26.
//  Copyright © 2017年 LiLingang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMIDConstants.h"

@interface HMIDBindItem : NSObject

/**
 三方类型，HMIDBindType
 */
@property (readonly) HMIDBindType thirdType;

/**
 三方Id
 */
@property (readonly) NSString *thirdId;

/**
 三方昵称
 */
@property (readonly) NSString *nickName;

/**
 绑定的时间，单位ms
 */
@property (readonly) int64_t bindDate;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
