//  HMServiceAPI+Chat.h
//  Created on 2017/12/21
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>
#import "HMServiceAPI+Message.h"

typedef NS_ENUM(NSUInteger, HMServiceAPIChatReportCategory) {
    HMServiceAPIChatReportCategoryPornographic,     // 色情
    HMServiceAPIChatReportCategoryHarass,           // 骚扰谩骂
    HMServiceAPIChatReportCategoryAdvertisement,    // 广告
    HMServiceAPIChatReportCategoryOther,            // 其他
};

typedef NS_ENUM(NSUInteger, HMServiceAPIChatErrorCode) {
    HMServiceAPIChatErrorCodeUnkown,
    HMServiceAPIChatErrorCodeUnFollow,      // 对方开启未关注不接收消息
    HMServiceAPIChatErrorCodeGag,           // 被禁言
};

@protocol HMServiceAPIChatData <NSObject>

@property (nonatomic, copy, readonly) NSString  *api_chatContent;       // 内容
@property (nonatomic, copy, readonly) NSDate    *api_chatSendTime;      // 发送时间
@property (nonatomic, copy, readonly) NSString  *api_chatOtherUserID;   // 消息的userID

@end


@protocol HMServiceChatAPI <HMServiceAPI>

/**
 *  @brief  发送消息
 *
 *  @param  otherUserID     对方的userIDß
 *
 *  @param  content         内容
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/私聊接口/addMsgUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)chat_uploadWithOtherUserID:(NSString *)otherUserID
                                          content:(NSString *)content
                                  completionBlock:(void (^)(BOOL success, NSString *message, HMServiceAPIChatErrorCode errorCode))completionBlock;


/**
 *  @brief  获取最新未读消息
 *
 *  @param  otherUserID     对方的userID
 *
 *  @param  lastItemTime    上条数据的时间戳（第一次为0）
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/私聊接口/getChatHeartBeatListUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)chat_queryUnreadMessageWithOtherUserID:(NSString *)otherUserID
                                                 lastItemTime:(NSTimeInterval)lastItemTime
                                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIChatData>> *chatDatas))completionBlock;

/**
 *  @brief  获取已往的消息
 *
 *  @param  otherUserID     对方的userID
 *
 *  @param  lastItemKey     上次服务器返的值(第一次可传-1或者nil)
 *
 *  @param  count           拉取个数
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/私聊接口/getChatHeartBeatListUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)chat_queryMessageWithOtherUserID:(NSString *)otherUserID
                                            lastItemKey:(NSString *)lastItemKey
                                                  count:(NSUInteger)count
                                        completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIChatData>> *chatDatas, NSString *lastItemKey))completionBlock;

/**
 *  @brief  举报接口
 *
 *  @param  otherUserID     对方的userID
 *
 *  @param  category        举报类别
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/举报接口/addReportUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)chat_reportWithOtherUserID:(NSString *)otherUserID
                                         category:(HMServiceAPIChatReportCategory)category
                                  completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  关注（取消）接口
 *
 *  @param  otherUserID     对方的userID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/举报接口/addReportUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)chat_followWithOtherUserID:(NSString *)otherUserID
                                  completionBlock:(void (^)(BOOL success, HMServiceAPIMessageMifitCircleUserInfoStatus follow, NSString *message))completionBlock;

@end




@interface HMServiceAPI (Chat) <HMServiceChatAPI>


@end
