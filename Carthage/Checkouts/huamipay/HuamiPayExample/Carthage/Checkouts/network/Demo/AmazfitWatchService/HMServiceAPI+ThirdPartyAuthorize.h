//
//  HMServiceAPI+ThirdPartyAuthorize.h
//  HMNetworkLayer
//
//  Created by 李宪 on 19/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>


@protocol HMServiceThirdPartyAuthorizeAPI <HMServiceAPI>

/**
 三方授权
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=160 
 */
- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeWithUserID:(NSString *)userID
                                               thirdPartyAppID:(NSString *)appID
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSString *redirectURL))completionBlock;

/**
 JavaScript授权
 @see http://aos-docs.private.mi-ae.cn/jsbridge/native-api/site/preVerifyJsApi/
 PS：考虑到参数来源于JavaScript，因此时间戳使用NSString类型。另外调用者需要判断参数合法性避免崩溃发生
 */
- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeForJavaScriptWithUserID:(NSString *)userID
                                                                     appKey:(NSString *)appKey
                                                                  timestamp:(NSString *)timestamp
                                                                      nonce:(NSString *)nonce
                                                                  signature:(NSString *)signature
                                                                     webURL:(NSString *)webURL
                                                                   apiNames:(NSArray<NSString *> *)apiNames
                                                            completionBlock:(void (^)(BOOL success, NSString *message, NSArray<NSString *> *authorizedAPINames))completionBlock;
 
@end


@interface HMServiceAPI (ThirdPartyAuthorize) <HMServiceThirdPartyAuthorizeAPI>
@end
