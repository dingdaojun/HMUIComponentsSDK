//
//  HMServiceAPI+Wechat.h
//  AmazfitWatch
//
//  Created by 朱立挺 on 2018/1/16.
//  Copyright © 2018年 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPIWechatAuthorizeData <NSObject>

@property (readonly) BOOL api_wechatAuthorizeDataBound;                 // 是否绑定了
@property (readonly) NSString *api_wechatAuthorizeDataNickname;         // 绑定名称

@end


@protocol HMWechatServiceAPI <HMServiceAPI>

- (id<HMCancelableAPI>)wechat_retrieveAuthorizeDataWithCompletionBlock:(void (^)(BOOL success, NSString *message, id <HMServiceAPIWechatAuthorizeData> authorizeData))completionBlock;

- (id<HMCancelableAPI>)wechat_authorizeWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSString *QRCodeLink)) completionBlock;

@end


@interface HMServiceAPI (Wechat) <HMWechatServiceAPI>
@end
