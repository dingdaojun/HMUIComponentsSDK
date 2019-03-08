//  UserInfoModel.m
//  Created on 2018/6/7
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)saveUserDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.userId forKey:@"uid"];
    [dict setObject:self.thirdId forKey:@"openId"];
    [dict setObject:self.nickname forKey:@"nickname"];
    [dict setObject:self.appToken forKey:@"token"];
    [dict setObject:self.avatarURL forKey:@"avatar"];
    [dict setObject:@(self.region) forKey:@"region"];
    
    //下面信息为模拟data
    [dict setObject:@"1993-07" forKey:@"birthday"];
    [dict setObject:@(1) forKey:@"gender"];
    [dict setObject:@(60) forKey:@"weight"];
    [dict setObject:@(170) forKey:@"height"];
    [dict setObject:@"mi" forKey:@"openType"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
