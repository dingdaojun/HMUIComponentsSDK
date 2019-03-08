//
//  HMIDRegistItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIDRegistItem : NSObject

/**
 是不是新用户
 */
@property (readonly) BOOL newUser;

/**
 注册时间 e.g.2015-8-14 16:10:33
 */
@property (readonly) NSString *registDate;

/**
 注册的区域，NSInteger值 eg.不限于 cn: 1  us: 2  sg:3 ...（详细的可by同幸）
 */
@property (nonatomic, assign) NSInteger region;

/**
 初始化

 @param dictionary 字典
 @return HMIDRegistItem
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
