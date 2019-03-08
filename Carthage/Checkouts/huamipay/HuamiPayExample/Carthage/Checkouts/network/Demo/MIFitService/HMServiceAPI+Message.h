//
//  Created on 2017/11/27
//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceAPIMessageStatus) {
    HMServiceAPIMessageStatusNew          = 1,      // 未读
    HMServiceAPIMessageStatusRead,                  // 已读
    HMServiceAPIMessageStatusDeleted,               // 已经删除
};


typedef NS_ENUM(NSUInteger, HMServiceAPIMessageType) {
    HMServiceAPIMessageTypeFriendRelation = 1,          // 亲友关系
    HMServiceAPIMessageTypeFriendDataUpdate ,           // 亲友数据更新(亲友列表页)
    HMServiceAPIMessageTypeFriendNotification ,         // 亲友提醒(亲友主页)
    HMServiceAPIMessageTypeFriendNotifyMessage ,        //
    HMServiceAPIMessageTypeFriendRelationAgree ,        // 亲友关注成功
    HMServiceAPIMessageTypeShowSleep ,                  // 睡眠
    HMServiceAPIMessageTypeShowStep ,                   // 步数
    HMServiceAPIMessageTypeShowHeartRate ,              // 心率
    HMServiceAPIMessageTypeShowHRV ,                    // 心率变异性
    HMServiceAPIMessageTypeShowBody ,                   // 身体数据
    HMServiceAPIMessageTypeWebview ,                    // 展示推送页面
    HMServiceAPIMessageTypeActivity ,                   // 活动
    HMServiceAPIMessageTypeDataReport ,                 // 健康周报
    HMServiceAPIMessageTypeMifitCircle ,                // 米动圈消息（小米运动）
    HMServiceAPIMessageTypeMifitPrivateMessage ,        // 用户私信（小米运动））
};

@protocol HMServiceAPIMessageData <NSObject>

@property (nonatomic, copy, readonly) NSString  *api_messageID;                         // 消息栏ID
@property (nonatomic, copy, readonly) NSString  *api_messageTitle;                      // 消息栏的标题
@property (nonatomic, copy, readonly) NSString  *api_messageContent;                    // 消息栏的内容

@property (nonatomic, copy, readonly) NSString  *api_messageUrl;                        // 消息栏如果是h5的话跳转链接
@property (nonatomic, copy, readonly) NSDate    *api_messageDataTime;                   // 消息的时间
@property (nonatomic, copy, readonly) NSString  *api_messageDataFolloweeID;             // 消息对方的userID
@property (nonatomic, copy, readonly) NSString  *api_messageDataIconUrl;                // 消息栏对方的头像
@property (nonatomic, copy, readonly) NSString  *api_messageNickName;                   // 消息对方的昵称
@property (nonatomic, assign, readonly) NSInteger api_messageDataCount;                 // 未读消息的个数
@property (nonatomic, assign, readonly) HMServiceAPIMessageStatus api_messageStatus;    // 消息栏的状态
@property (nonatomic, assign, readonly) HMServiceAPIMessageType api_messageType;        // 消息栏的类型

@end

typedef NS_ENUM(NSUInteger, HMServiceAPIMessageMifitCircleUserInfoGrade) {
    HMServiceAPIMessageMifitCircleUserInfoGradeOrdinary = 1,     // 普通用户
    HMServiceAPIMessageMifitCircleUserInfoGradeVIP = 2,          // VIP
    HMServiceAPIMessageMifitCircleUserInfoGradeOfficial = 3,    // 官方账号
};

typedef NS_ENUM(NSUInteger, HMServiceAPIMessageMifitCircleUserInfoStatus) {
    HMServiceAPIMessageMifitCircleUserInfoStatusFollow,             // 关注
    HMServiceAPIMessageMifitCircleUserInfoStatusUnfollow,           // 未关注
    HMServiceAPIMessageMifitCircleUserInfoStatusFollowEach,         // 相互关注
};


typedef NS_ENUM(NSUInteger, HMServiceAPIMessageMifitCircleType) {
    HMServiceAPIMessageMifitCircleTypeLike = 1,             // 点赞
    HMServiceAPIMessageMifitCircleTypeComment = 2,          // 评论
    HMServiceAPIMessageMifitCircleTypeFollow = 3,           // 关注
    HMServiceAPIMessageMifitCircleTypeSelected = 4,         // 精选
    HMServiceAPIMessageMifitCircleTypePrivateLetter = 6,    // 私信
    HMServiceAPIMessageMifitCircleTypeTopicLike = 7,        // topic点赞
    HMServiceAPIMessageMifitCircleTypeDailyRankings = 8,    // 每日排行
};

static inline HMServiceAPIMessageMifitCircleUserInfoStatus mifitCircleFollowStatusWithString(NSString *string) {
    NSDictionary *map = @{@"follow" : @(HMServiceAPIMessageMifitCircleUserInfoStatusFollow),
                          @"unfollow" : @(HMServiceAPIMessageMifitCircleUserInfoStatusUnfollow),
                          @"followEach" : @(HMServiceAPIMessageMifitCircleUserInfoStatusFollowEach)};
    return [map[string] integerValue];
}

@protocol HMServiceAPIMessageMifitCircleUserInfoData <NSObject>

@property (nonatomic, copy, readonly) NSString  *api_mifitCircleUserInfoAvatar;                                         // 头像
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleUserInfoSummary;                                        // 简介
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleUserInfoID;                                             // 户ID
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleUserInfoNickName;                                       // 昵称

@property (nonatomic, assign, readonly) HMServiceAPIMessageMifitCircleUserInfoGrade  api_mifitCircleUserInfoGrade;      // 用户等级
@property (nonatomic, assign, readonly) HMServiceAPIMessageMifitCircleUserInfoStatus  api_mifitCircleUserInfoStatus;    // 状态
@property (nonatomic, assign, readonly) BOOL  api_mifitCircleUserInfReceiveStrangerMessage;                             // 是否接收陌生人消息

@end


@protocol HMServiceAPIMessageMifitCircleData <NSObject>

@property (nonatomic, copy, readonly) NSString  *api_mifitCircleCommentContent;         // 评论内容
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleCommentID;              // 评论ID
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleContent;                // 评论内容 topic点赞时，内容为topicName app用

@property (nonatomic, copy, readonly) NSString  *api_mifitCirclePostID;                 // 帖子ID
@property (nonatomic, copy, readonly) NSString  *api_mifitCirclePostImage;              // 帖子图片
@property (nonatomic, copy, readonly) NSDate    *api_mifitCircleDate;                   // 行为时间
@property (nonatomic, copy, readonly) NSString  *api_mifitCircleTopicID;                // 话题ID


@property (nonatomic, strong, readonly) id<HMServiceAPIMessageMifitCircleUserInfoData>  api_mifitCircleUserInfo;           // 用户
@property (nonatomic, strong, readonly) id<HMServiceAPIMessageMifitCircleUserInfoData>  api_mifitCircleReceiveUserInfo;    // 被回复用户

@property (nonatomic, assign, readonly) NSUInteger  api_mifitCircleUnreadCount;                     // 未读消息数量
@property (nonatomic, assign, readonly) HMServiceAPIMessageMifitCircleType api_mifitCircleType;     // 未读消息类型

@end


@protocol HMServiceMessageAPI <HMServiceAPI>

/**
 *  @brief  获取消息栏列表
 *
 *  @param  completionBlock  回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/message-controller/listUsingGET_7
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)message_dataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMessageData>> *messageDatas))completionBlock;


/**
 *  @brief  获取消息栏列表
 *
 *  @param  messageID        消息ID
 *
 *  @param  status           消息的状态
 *
 *  @param  completionBlock  回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/message-controller/putUsingPUT_4
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)message_updateWithMessageID:(NSString *)messageID
                                            status:(HMServiceAPIMessageStatus)status
                                   completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  获取米动圈列表
 *
 *  @param  count               请求个数
 *
 *  @param  lastKey             上次请求的key
 *
 *  @param  newMessage          是否是新的消息
 *
 *  @param  completionBlock     回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/用户类接口/getUserMsgListUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)message_mifitCircleWithCount:(NSInteger)count
                                            lastKey:(NSString *)lastKey
                                         newMessage:(BOOL)newMessage
                                    completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIMessageMifitCircleData>> *mifitCircleDatas, NSString *nextKey))completionBlock;


/**
 *  @brief  删除米动圈消息
 *
 *  @param  completionBlock     回调方法
 *
 *  @see    http://huami-sport-circle-staging.mi-ae.net/swagger-ui.html#!/用户类接口/delUserMsgUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)message_mifitCircleDeleteWithCompletionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

@end


@interface HMServiceAPI (Message) <HMServiceMessageAPI>

@end
