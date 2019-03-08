//
//  HMIDVerifyAppTokenRequestTask.h
//  HMHealth
//
//  Created by 李林刚 on 2016/12/5.
//  Copyright © 2016年 HM iOS. All rights reserved.
//

#import "HMIDRequestTask.h"


/**
 验证apptoken的有效性
 error_code: // 0100/0101/0102/0108
 
 userid:{value1}, //user id in HuaMi Id system
 
 third_name:{xiaomi/wechat}, //third-party name
 
 third_id: {} // third-party id
 
 idc_flag: {1 or 2} // user located node. 1 denotes China, and 2 denotes US
 */
@interface HMIDVerifyAppTokenRequestTask : HMIDRequestTask

/**
 创建一个检查appToken有效性的请求
 
 @param appName  线下账号系统分配给第三方的appname
 @param appToken 现有的apptoken
 @return HMIDVerifyAppTokenRequestTask 实例
 */
- (nonnull instancetype)initWithAppName:(nonnull NSString *)appName
                               appToken:(nonnull NSString *)appToken;

@end
