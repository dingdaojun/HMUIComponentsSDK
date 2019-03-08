//
//  NSError+HMServiceAPI.h
//  HMNetworkLayer
//
//  Created by 李宪 on 18/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/Home/Page/index/page_id/60
 */
typedef NS_ENUM(NSInteger, HMServiceAPIError) {
    HMServiceAPIErrorNone,                      // 成功
    HMServiceAPIErrorNetwork,                   // 网络问题
    HMServiceAPIErrorTimeout,                   // 超时
    HMServiceAPIErrorResponseDataFormat,        // 返回数据格式错误
    HMServiceAPIErrorServerInternal,            // 服务端内部错误
    HMServiceAPIErrorParameters,                // 参数错误
    HMServiceAPIErrorInvalidUserID,             // 无效用户ID
    HMServiceAPIErrorInvalidToken,              // 无效Token
    HMServiceAPIErrorMutexLogin,                // 单点登录
    HMServiceAPIErrorContentSensitive,          // 内容敏感
    HMServiceAPIErrorUnknown,                   // 未知错误
};

FOUNDATION_EXPORT NSErrorDomain const HMServiceAPIErrorDomain;

FOUNDATION_EXPORT NSString* const HMServiceAPIErrorUserInfoMutexLoginTimeKey;


@interface NSError (HMServiceAPI)

+ (instancetype)errorWithHMServiceAPIError:(HMServiceAPIError)error;
+ (instancetype)errorWithHMServiceAPIError:(HMServiceAPIError)error
                                  userInfo:(NSDictionary *)userInfo;

@end
