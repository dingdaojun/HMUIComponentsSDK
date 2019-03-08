//  HMServiceAPI+EventReminder.h
//  Created on 2017/12/20
//  Description <#文件描述#>

//  Copyright © 2017年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

typedef NS_ENUM(NSInteger, HMServiceAPIEventReminderFrom) {
    HMServiceAPIEventReminderFromMiFit          = 0,
    HMServiceAPIEventReminderFromMiDongAssitant = 1,
    HMServiceAPIEventReminderFromCloud          = 2,
};

typedef NS_ENUM(NSUInteger, HMServiceAPIEventReminderOperation) {
    HMServiceAPIEventReminderOperationClose = 0,        // 关闭的事件提醒
    HMServiceAPIEventReminderOperationOpen = 1,         // 打开的事件提醒
    HMServiceAPIEventReminderOperationDelete = 2,       // 删除的事件提醒
};

@protocol HMServiceAPIEventReminderData <NSObject>

@property (nonatomic, copy, readonly) NSString  *api_eventReminderID;               // ID
@property (nonatomic, copy, readonly) NSString  *api_eventReminderLoop;             // 循环类型
@property (nonatomic, copy, readonly) NSDate    *api_eventReminderStartDate;        // 开始时间
@property (nonatomic, copy, readonly) NSDate    *api_eventReminderStopDate;         // 结束时间
@property (nonatomic, copy, readonly) NSString  *api_eventReminderTitle;            // 内容

@property (nonatomic, assign, readonly) long long                           api_eventReminderCreatedDate;   // 创建时间(因为这个会被服务器作为主键进行处理故不做转化)
@property (nonatomic, assign, readonly) HMServiceAPIEventReminderFrom       api_eventReminderFrom;          // 来源
@property (nonatomic, assign, readonly) HMServiceAPIEventReminderOperation  api_eventReminderOperation;     // 操作类型

@end


@protocol HMServiceEventReminderAPI <HMServiceAPI>

/**
 *  @brief  获取事件提醒列表
 *
 *  @param  count           请求个数
 *
 *  @param  nextID          请求的ID（第一次可传空）
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/event-reminder-controller/getReadUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)eventReminder_dataWithCount:(NSUInteger)count
                                            nextID:(NSString *)nextID
                                   completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIEventReminderData>> *eventReminderDatas, NSString *next))completionBlock;

/**
 *  @brief  获取事件提醒列表
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/event-reminder-controller/getUnreadUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)eventReminder_validDataWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIEventReminderData>> *eventReminderDatas))completionBlock;

/**
 *  @brief  上传事件提醒
 *
 *  @param  datas           事件提醒的数组
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/event-reminder-controller/getReadUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)eventReminder_uploadWithDatas:(NSArray<id<HMServiceAPIEventReminderData>> *)datas
                                     completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;

/**
 *  @brief  删除事件提醒
 *
 *  @param  data            事件提醒的数据
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/event-reminder-controller/getReadUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)eventReminder_deleteWithData:(id<HMServiceAPIEventReminderData>)data
                                    completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


@end



@interface HMServiceAPI (EventReminder) <HMServiceEventReminderAPI>


@end
