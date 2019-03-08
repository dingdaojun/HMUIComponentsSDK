//
//  HMIDAuthItem.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/10.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMIDAuthItem : NSObject

/**
 第三方获取的code或者token,(code授权：mi/wechat token授权:google/facebook)
 */
@property (nonnull, nonatomic, copy) NSString *thirdToken;

/**
 第三方申请相对与用户的唯一标示
 */
@property (nullable, nonatomic, copy) NSString *thirdId;

/**
 第三方授权返给的region信息，邮箱登录必定有该参数
 */
@property (nullable, nonatomic, copy) NSString *userRegion;

@end
