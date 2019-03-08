//
//  Created on 2017/11/3
//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

/**
 第三方信息
 */
@protocol HMServiceAPIThirdPartyAccessData <NSObject>

@property (nonatomic, copy, readonly) NSString *api_thirdPartyAccessDataAppID;                  //开放平台中的appid
@property (nonatomic, copy, readonly) NSString *api_thirdPartyAccessDataUserID;                 //三方的userID
@property (nonatomic, copy, readonly) NSString *api_thirdPartyAccessDataAccessToken;            //三方的AccessToken
@property (nonatomic, copy, readonly) NSString *api_thirdPartyAccessDataNickName;               //三方的昵称
@property (nonatomic, assign, readonly) NSTimeInterval api_thirdPartyAccessDataExpiresTime;     //三方的有效时长

@end


@protocol HMServiceThirdPartyAccessAPI <HMServiceAPI>

/**
 *  @brief 绑定三方平台信息
 *
 *  @param accessData   三方信息
 *
 *  @param completionBlock  回调方法
 *
 *  @see    http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=107
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)thirdPartyAccess_bindWithAccessData:(id<HMServiceAPIThirdPartyAccessData>)accessData
                                           completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  解绑三方平台信息
 *
 *  @param  accessData   三方信息
 *
 *  @param  completionBlock  回调方法
 *
 *  @see    http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=108
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)thirdPartyAccess_unbindWithAccessData:(id<HMServiceAPIThirdPartyAccessData>)accessData
                                             completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  获取历史数据
 *
 *  @param  thirdAppID   三方的appID
 *
 *  @param  completionBlock  回调方法
 *
 *  @see    http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=150
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)thirdPartyAccess_dataWithThirdAppID:(NSString *)thirdAppID
                                           completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIThirdPartyAccessData> thirdPartyData))completionBlock;

@end

@interface HMServiceAPI (ThirdPartyAccess) <HMServiceThirdPartyAccessAPI>
@end
