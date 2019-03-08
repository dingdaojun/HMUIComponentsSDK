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
- (id<HMCancelableAPI>)thirdPartyAuthorize_authorizeWithThirdPartyAppID:(NSString *)appID
                                                        completionBlock:(void (^)(BOOL success, NSString *message, NSString *redirectURL))completionBlock;


@end


@interface HMServiceAPI (ThirdPartyAuthorize) <HMServiceThirdPartyAuthorizeAPI>
@end
