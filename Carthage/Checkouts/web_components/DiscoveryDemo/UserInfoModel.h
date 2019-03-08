//  UserInfoModel.h
//  Created on 2018/6/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *appToken;

/**
 注册的区域，NSInteger值 eg.不限于 cn: 1  us: 2  sg:3 ...（详细的可by同幸）
 */
@property (nonatomic, assign) NSInteger region;

/**
 昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 头像URL
 */
@property (nonatomic, strong) NSString *avatarURL;

/**
 三方唯一ID
 */
@property (nonatomic, strong) NSString *thirdId;

- (void)saveUserDict;

@end
