//  HMServiceAPI+BUSCard.h
//  Created on 2018/6/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>

typedef NS_ENUM(NSUInteger, HMServiceBUSCardCityStatus) {
    HMServiceBUSCardCityStatusUnkown,
    HMServiceBUSCardCityStatusPreOnline,
    HMServiceBUSCardCityStatusOnline,
    HMServiceBUSCardCityStatusTest,
    HMServiceBUSCardCityStatusOffline,
    HMServiceBUSCardCityStatusDelete,
};

typedef NS_ENUM(NSUInteger, HMServiceBUSCardStatus) {
    HMServiceBUSCardStatusUnkown,                                               // 未识别的状态
    HMServiceBUSCardStatusBinding,                                              // 已开通
    HMServiceBUSCardStatusUnopened,                                             // 未开通
    HMServiceBUSCardStatusException,                                            // 异常
};

typedef NS_ENUM(NSInteger, HMServiceBUSCardTransactionRecordType) {
    HMServiceBUSCardTransactionRecordTypeOpenAndRecharge = 0,               // 开卡加充值
    HMServiceBUSCardTransactionRecordTypeConsumption = 1,                   // 消费
};

NS_ASSUME_NONNULL_BEGIN

@protocol HMServiceAPIBUSCard <NSObject>

@property (readonly) NSString * _Nullable api_busCardID;                                    // 公交卡的ID
@property (readonly) NSString * _Nullable api_busCardCityCode;                              // 城市ID
@property (readonly) NSString * _Nullable api_busCardApplicationID;                         // 应用ID
@property (readonly) NSDate * _Nullable api_busCardLastUpdateTime;                          // 最后一次的状态变更时间（最近开通／解绑的时间）
@property (readonly) NSString * _Nullable api_busCardStatus;                                // 公交卡的状态

@end
@protocol HMServiceAPIBUSCardTransactionRecord <NSObject>

@property (readonly) NSDate * _Nullable api_busCardTransactionRecordTime;                   // 交易时间
@property (readonly) NSString * _Nullable api_busCardTransactionRecordState;                // 交易状态
@property (readonly) NSInteger api_busCardTransactionRecordAmount;                          // 交易金额
@property (readonly) NSString * _Nullable api_busCardTransactionRecordLocation;             // 地点
@property (readonly) NSString * _Nullable api_busCardTransactionRecordServiceProvider;      // 服务供应商
@property (readonly) NSString * _Nullable api_busCardTransactionRecordType;                 // 交易类型

@end



@protocol HMServiceAPIBUSCardCity <NSObject>

@property (readonly) NSString * _Nullable api_busCardCityName;                              // 城市名称
@property (readonly) NSString * _Nullable api_busCardCityID;                                // 城市ID
@property (readonly) NSString * _Nullable api_busCardCityCardName;                          // 卡片名称
@property (readonly) NSString * _Nullable api_busCardCityAID;                               // 公交应用aid
@property (readonly) NSString * _Nullable api_busCardCityBusCode;                           // 公交编码
@property (readonly) NSString * _Nullable api_busCardCityCardCode;                          // 卡片编码
@property (readonly) NSString * _Nullable api_busCardCityServiceScope;                      // 应用范围
@property (readonly) NSString * _Nullable api_busCardCityOpenedImgUrl;                      // 已开通卡背景图片
@property (readonly) NSString * _Nullable api_busCardCityUnopenedImgUrl;                    // 未开通卡背景图片
@property (readonly) NSDate * _Nullable api_busCardCityOpenTime;                            // 开卡时间
@property (readonly) NSString * _Nullable api_busCardCityCardID;                            // 卡片ID
@property (readonly) NSString * _Nullable api_busCardCityOrderID;                           // 异常订单号
@property (readonly) BOOL api_busCardCityHasSubCity;                                        // 是否有子城市
@property (readonly) NSString * _Nullable api_busCardCityFetchApduMode;                     // fetch apdu mode
@property (readonly) NSString * _Nullable api_busCardCityParentCityID;                      // parent 城市ID
@property (readonly) NSString * _Nullable api_busCardCityVisibleGroups;                     // visibleGroups
@property (readonly) NSString * _Nullable api_busCardCityXiaomiCardName;                    // 小米的卡片名字
@property (readonly) NSString * _Nullable api_busCardCityXiaomiActionToken;                 // 小米apdu token
@property (readonly) NSInteger api_busCardCityXiaomiCardStatus;                             // 小米卡状态
@property (readonly) NSArray <NSString *> * _Nullable api_busCardCitySupportApps;           // support app

@property (readonly) HMServiceBUSCardStatus  api_busCardCityCardStatus;                     // 卡的状态
@property (readonly) HMServiceBUSCardCityStatus api_busCardCityStatus;                      // 城市状态

@end

@protocol HMServiceAPIBUSCardCompanyNoticeAppVersion <NSObject>

@property (readonly) NSString * _Nullable api_busCardCompanyNoticeAPPVersion;               // 支持的app版本号
@property (readonly) NSString * _Nullable api_busCardCompanyNoticeAPPType;                  // 支持的手机的类型

@end

@protocol HMServiceAPIBUSCardCompanyNotice <NSObject>

@property (readonly) NSArray <NSString *> * _Nullable api_busCardCompanyNoticeCities;       // 城市列表
@property (readonly) NSString * _Nullable api_busCardCompanyNoticeContext;                  // 公告内容
@property (readonly) NSString * _Nullable api_busCardCompanyNoticeCrossBarUrl;              // 横栏跳转路径
@property (readonly) NSString * _Nullable api_busCardCompanyNoticeID;                       // 公告的ID
@property (readonly) NSDate * _Nullable api_busCardCompanyNoticeStartTime;                  // 投放开始时间
@property (readonly) NSDate * _Nullable api_busCardCompanyNoticeEndTime;                    // 投放结束时间
@property (readonly) NSDate * _Nullable api_busCardCompanyNoticeUpdateTime;                 // 更新时间
@property (readonly) NSArray * _Nullable api_busCardCompanyNoticeTypes;                     // 循环类型
@property (readonly) NSString * _Nullable api_busCardCompanyNoticeLoopType;                 // 公告类型
@property (readonly) BOOL  api_busCardCompanyNoticeSupportCrossBarJump;                     // 是否支持横栏跳转

@property (readonly) NSArray <id<HMServiceAPIBUSCardCompanyNoticeAppVersion>> * _Nullable api_busCardCompanyNoticeAppVersions;                 // 支持的app版本号

@end


@protocol HMServiceBUSCardAPI <HMServiceAPI>


/**
 *  @brief  绑定公交卡接口 (绑卡)
 *
 *  @param  deviceID        设备ID
 *
 *  @param  card            卡片的相关信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45binding45controller/postUsingPOST_2
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_bindWithDeviceID:(NSString *)deviceID
                                                     card:(id<HMServiceAPIBUSCard>)card
                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  已绑定的公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45binding45controller/listUsingGET_1
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_retrieveWithDeviceID:(NSString *)deviceID
                                              completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCard>> * _Nullable cards))completionBlock;

/**
 *  @brief  解除公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  cardID          卡ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45binding45controller/deleteUsingDELETE_1
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_unbindWithDeviceID:(NSString *)deviceID
                                                     cardID:(NSString *)cardID
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;


/**
 *  @brief  获取交易记录列表    （获取交易记录）
 *
 *  @param  cityID          城市ID
 *
 *  @param  cardID          卡ID
 *
 *  @param  type            交易类型
 *
 *  @param  nextTime        加载下个数据的时间
 *
 *  @param  limit           交易个数（建议为10）
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45transaction45controller/listUsingGET_3
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_transactionRecordWithCityID:(NSString *)cityID
                                                              cardID:(NSString *)cardID
                                                                type:(HMServiceBUSCardTransactionRecordType)type
                                                            nextTime:(NSDate * _Nullable)nextTime
                                                               limit:(NSInteger)limit
                                                     completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime))completionBlock;

/**
 *  @brief  上传交易记录  （上传交易记录）
 *
 *  @param  cityID          城市ID
 *
 *  @param  cardID          卡ID
 *
 *  @param  records         交易信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45transaction45controller/postUsingPOST_3
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_uploadTransactionRecordWithCityID:(NSString *)cityID
                                                                    cardID:(NSString *)cardID
                                                                   records:(NSArray<id<HMServiceAPIBUSCardTransactionRecord>> *)records
                                                           completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;


/**
 *  @brief  获取固定的城市列表       (已开通城市列表)
 *
 *  @param  deviceID            设备ID
 *
 *  @param  completionBlock     回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45city45controller/listUsingGET_2
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_citiesWithDeviceID:(NSString *)deviceID
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities))completionBlock;

/**
 *  @brief  获取固定的城市详情   (城市详情)
 *
 *  @param  cityID          城市ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45city45controller/getUsingGET_9
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_cityWithID:(NSString *)cityID
                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message, id<HMServiceAPIBUSCardCity> _Nullable city))completionBlock;

/**
 *  @brief  获取固定的城市详情 (三合一)
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/bus45card45city45controller/getUserCitiesUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_cityWithDeviceID:(NSString *)deviceID
                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable cities))completionBlock;

/**
 *  @brief  获取公交卡公告
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-staging-admin.private.mi-ae.net/swagger-ui.html#!/bus45notice45controller/listUsingGET_3
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_busCompanyNoticeWithCompletionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices))completionBlock;


/**
 *  @brief  获取某个城市公交卡公告
 *
 *  @param  cityID          城市ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-staging-admin.private.mi-ae.net/swagger-ui.html#!/bus45notice45controller/listUsingGET_3
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCard_busCompanyNoticeWithCityID:(NSString *)cityID
                                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCompanyNotice>> * _Nullable companyNotices))completionBlock;


@end

NS_ASSUME_NONNULL_END

@interface HMServiceAPI (BUSCard) <HMServiceBUSCardAPI>
@end

@interface NSDictionary (HMServiceAPIBUSCardCity) <HMServiceAPIBUSCardCity>
@end
