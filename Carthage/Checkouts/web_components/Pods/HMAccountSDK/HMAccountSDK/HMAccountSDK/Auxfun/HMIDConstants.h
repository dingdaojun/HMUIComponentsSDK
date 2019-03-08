//
//  HMAccountConstants.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/9.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#ifndef HMAccountConstants_h
#define HMAccountConstants_h

/**Token 形式*/
typedef NSString * HMIDTokenGrantTypeOptionKey;
/**access_token 形式 e.g. facebook、email、phone*/
static HMIDTokenGrantTypeOptionKey const HMIDTokenGrantTypeOptionKeyAccessToken = @"access_token";
/**request_token 形式 e.g. mi、wechat、google*/
static HMIDTokenGrantTypeOptionKey const HMIDTokenGrantTypeOptionKeyRequestToken = @"request_token";

/**账号绑定类型*/
typedef NSString * HMIDBindType;

static HMIDBindType const HMIDBindTypeWechat    = @"wechat";
static HMIDBindType const HMIDBindTypeMI        = @"xiaomi";
static HMIDBindType const HMIDBindTypeGoogle    = @"google";
static HMIDBindType const HMIDBindTypeFacebook  = @"facebook";
static HMIDBindType const HMIDBindTypeEmail     = @"huami";
static HMIDBindType const HMIDBindTypePhone     = @"huami_phone";

#endif /* HMAccountConstants_h */
