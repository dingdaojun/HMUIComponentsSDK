//
//  HMServiceAPI+Social.h
//  HMNetworkLayer
//
//  Created by 李宪 on 20/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

@protocol HMServiceAPISocialUser <NSObject>

@property (nonatomic, copy, readonly) NSString *api_socialUserID;                           // 用户ID
@property (nonatomic, copy, readonly) NSString *api_socialUserName;                         // 用户名
@property (nonatomic, copy, readonly) NSString *api_socialUserAvatarURL;                    // 用户头像URL

@property (nonatomic, assign, readonly) BOOL api_socialUserIsFriend;                        // 是否是我的朋友
@property (nonatomic, strong, readonly) NSDate *api_socialUserBecameFriendTime;             // 成为朋友的时间
@property (nonatomic, strong, readonly) NSDate *api_socialUserUpdateTime;                   // 更新时间
@property (nonatomic, copy, readonly) NSString *api_socialUserRemark;                       // 我对他/她的备注
@property (nonatomic, assign, readonly) NSUInteger api_socialUserSendConcernTimes;          // 发送关心给朋友的次数
@property (nonatomic, assign, readonly) NSUInteger api_socialUserReceiveConcernTimes;       // 被朋友关心的次数

@property (nonatomic, assign, readonly) NSUInteger api_socialUserStepCount;                 // 用户步数
@property (nonatomic, assign, readonly) NSUInteger api_socialUserSleepMinutes;              // 用户睡眠分钟数
@property (nonatomic, assign, readonly) double api_socialUserWeight;                        // 用户体重

@end


@protocol HMServiceAPISocialUserHealthData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_socialUserHealthDataDate;                           // 数据日期
@property (nonatomic, assign, readonly) NSUInteger api_socialUserHealthDataStepCount;                   // 步数
@property (nonatomic, assign, readonly) NSUInteger api_socialUserHealthDataDistanceInMeters;            // 走路距离，单位米

@property (nonatomic, strong, readonly) NSDate *api_socialUserHealthDataSleepBeginTime;                 // 睡眠开始时间
@property (nonatomic, strong, readonly) NSDate *api_socialUserHealthDataSleepEndTime;                   // 睡眠结束时间
@property (nonatomic, assign, readonly) NSUInteger api_socialUserHealthDataDeepSleepMinutes;            // 深睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_socialUserHealthDataLightSleepMinutes;           // 浅睡眠分钟数
@property (nonatomic, assign, readonly) NSUInteger api_socialUserHealthDataManuallySleepMinutes;        // 手动编辑睡眠分钟数

@property (nonatomic, assign, readonly) double api_socialUserHealthDataCalorie;                         // 卡路里

@end

// 亲友消息类型
typedef NS_ENUM(NSUInteger, HMServiceAPISocialMessageType) {
    HMServiceAPISocialMessageTypeRemindFriend,          // 关爱好友
    HMServiceAPISocialMessageTypeApplyFriend,           // 申请加好友
    HMServiceAPISocialMessageTypeAcceptFriend,          // 接受加好友申请
    HMServiceAPISocialMessageTypeRejectFriend,          // 拒绝加好友申请
    HMServiceAPISocialMessageTypeDeleteFriend           // 删除好友
};

// 亲友消息
@protocol HMServiceAPISocialMessage <NSObject>

@property (nonatomic, copy, readonly) NSString *api_socialMessageID;                                // ID
@property (nonatomic, strong, readonly) NSDate *api_socialMessageTime;                              // 时间
@property (nonatomic, assign, readonly) HMServiceAPISocialMessageType api_socialMessageType;        // 类型
@property (nonatomic, copy, readonly) NSString *api_socialMessageFromUserID;                        // 发送消息用户
@property (nonatomic, copy, readonly) NSString *api_socialMessageToUserID;                          // 接受消息用户

@end


@protocol HMServiceSocialAPI <HMServiceAPI>

/**
 搜索用户
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=428
 */
- (id<HMCancelableAPI>)social_searchUserByID:(NSString *)searchUserID
                             completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialUser>> *users))completionBlock;

/**
 获取好友列表
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=69
 @param offset 当前已有的亲友NSArray count。 e.g friends.count
 */
- (id<HMCancelableAPI>)social_friendsWithOffset:(NSUInteger)offset
                                completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialUser>> *users, BOOL more))completionBlock;

/**
 添加好友
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=65
 PS: 发起者是华米id，to_uid一定是华米id;
 发起者是小米id，to_uid可能华米id也可能是小米id，由服务器端判断。
 上面两句话是接口文档上写的，我测试的时候发现在test环境下使用小米id一直404。使用华米id是正常的
 */
- (id<HMCancelableAPI>)social_applyForFriendToUserID:(NSString *)toUserID
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 接受/拒绝好友申请
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=66
 */
- (id<HMCancelableAPI>)social_acceptFriendInvitationFromUserID:(NSString *)fromUserID
                                               completionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPISocialUser>user))completionBlock;

- (id<HMCancelableAPI>)social_rejectFriendInvitationFromUserID:(NSString *)fromUserID
                                               completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 删除好友
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=67
 */
- (id<HMCancelableAPI>)social_deleteFriendWithUserID:(NSString *)friendUserID
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 关爱
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=68
 */
- (id<HMCancelableAPI>)social_sendConcernToFriendWithUserID:(NSString *)friendUserID
                                            completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 获取好友健康数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=70
 */
- (id<HMCancelableAPI>)social_friendHealthDataWithFriendUserID:(NSString *)friendUserID
                                                      fromDate:(NSDate *)fromDate
                                                       endDate:(NSDate *)endDate
                                               completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialUserHealthData>> *healthDatas))completionBlock;

/**
 获取好友消息
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=113
 @param offset 当前已有的消息NSArray count。 e.g messages.count
 PS：此接口暂时没有用到，现在消息是从推送获得的
 */
- (id<HMCancelableAPI>)social_friendMessagesWithOffset:(NSUInteger)offset
                                       completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPISocialMessage>> *messages, BOOL more))completionBlock;

/**
 修改好友备注
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=362
 */
- (id<HMCancelableAPI>)social_modifyFriendRemark:(NSString *)remark
                                    friendUserID:(NSString *)friendUserID
                                 completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


/**
 *  @brief  获取亲友分享的地址
 *
 *  @param  avatar          头像地址
 *
 *  @param  nickName        用户昵称
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)social_shareWithAvatar:(NSString *)avatar
                                     nickName:(NSString *)nickName
                              completionBlock:(void (^)(BOOL success, NSString *message, NSString *shareUrl))completionBlock;

@end

@interface HMServiceAPI (Social) <HMServiceSocialAPI>
@end
