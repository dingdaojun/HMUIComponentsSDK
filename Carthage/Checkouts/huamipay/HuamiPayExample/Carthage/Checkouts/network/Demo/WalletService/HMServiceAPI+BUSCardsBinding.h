//  HMServiceAPI+BUSCardsBinding.h
//  Created on 2018/2/22
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>
#import "HMServiceAPI+BUSCard.h"


typedef NS_ENUM(NSInteger, HMServiceBUSCardsTransactionRecordType) {
    HMServiceBindBUSCardsTransactionRecordTypeOpenAndRecharge = 0,      // 开卡加充值
    HMServiceBindBUSCardsTransactionRecordTypeConsumption = 1,          // 消费
};


NS_ASSUME_NONNULL_BEGIN

@protocol HMServiceAPIBUSCardsBindingCard <NSObject>

@property (readonly) NSString *api_busCardsBindingCardID;                       // 公交卡的ID
@property (readonly) NSString *api_busCardsBindingCardCityCode;                 // 城市ID
@property (readonly) NSString *api_busCardsBindingCardApplicationID;            // 应用ID
@property (readonly) NSDate *api_busCardsBindingCardLastUpdateTime;             // 最后一次的状态变更时间（最近开通／解绑的时间）
@property (readonly) NSString *api_busCardsBindingCardStatus;                   // 最后一次的状态变更时间

@end

@protocol HMServiceAPIBUSCardsTransactionRecord <NSObject>

@property (readonly) NSDate *api_busCardsTransactionRecordTime;                 // 交易时间
@property (readonly) NSString *api_busCardsTransactionRecordState;              // 交易状态
@property (readonly) NSInteger api_busCardsTransactionRecordAmount;             // 交易金额
@property (readonly) NSString *api_busCardsTransactionRecordLocation;           // 地点
@property (readonly) NSString *api_busCardsTransactionRecordServiceProvider;    // 服务供应商
@property (readonly) NSString *api_busCardsTransactionRecordType;               // 交易类型

@end

@protocol HMServiceAPIBUSCardsCity <NSObject>

@property (readonly) NSString * _Nullable api_busCardsCityName;                             // 城市名称
@property (readonly) NSString * _Nullable api_busCardsCityID;                               // 城市ID
@property (readonly) NSString * _Nullable api_busCardsCityCardName;                         // 卡片名称
@property (readonly) NSString * _Nullable api_busCardsCityAID;                              // 公交应用aid
@property (readonly) NSString * _Nullable api_busCardsCityBusCode;                          // 公交编码
@property (readonly) NSString * _Nullable api_busCardsCityCardCode;                         // 卡片编码
@property (readonly) NSString * _Nullable api_busCardsCityServiceScope;                     // 应用范围
@property (readonly) NSString * _Nullable api_busCardsCityOpenedImgUrl;                     // 已开通卡背景图片
@property (readonly) NSString * _Nullable api_busCardsCityUnopenedImgUrl;                   // 未开通卡背景图片
@property (readonly) NSDate * _Nullable api_busCardsCityOpenTime;                           // 开卡时间
@property (readonly) NSString * _Nullable api_busCardsCityCardID;                           // 卡片ID
@property (readonly) NSString * _Nullable api_busCardsCityOrderID;                          // 异常订单号
@property (readonly) HMServiceBUSCardStatus  api_busCardsCityCardStatus;                    // 卡的状态
@property (readonly) BOOL api_busCardsCityHasSubCity;                                       // 是否有子城市

@end


@protocol HMServiceAPIWalletConfiguration <NSObject>

@property (readonly) NSString * _Nullable api_busCardsCityConfigurationPone;    // 手机号

@end

@protocol HMServiceBUSCardsBindingAPI <HMServiceAPI>

/**
 *  @brief  绑定公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  deviceType      设备类型
 *
 *  @param  card            卡片信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    https://huami.sharepoint.cn/:w:/r/sites/teams/bnd/_layouts/15/WopiFrame2.aspx?sourcedoc=%7B92D6369A-CD84-4E1E-9013-96FD59365986%7D&file=接入公交卡API接口文档.docx&action=default&IsList=1&ListId=%7BE9D03622-A916-40C1-AD16-E0F9CC89107B%7D&ListItemId=553
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_bindWithDeviceID:(NSString *)deviceID
                                                       deviceType:(NSInteger)deviceType
                                                             card:(id<HMServiceAPIBUSCardsBindingCard>)card
                                                  completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  解除公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  cardID          卡ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_unbindWithDeviceID:(NSString *)deviceID
                                                             cardID:(NSString *)cardID
                                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  解除设备下的所有公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_unbindWithDeviceID:(NSString *)deviceID
                                                    completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  已绑定的公交卡
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_boundCardsWithDeviceID:(NSString *)deviceID
                                                        completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsBindingCard>> * _Nullable cards))completionBlock;

/**
 *  @brief  获取交易记录列表
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
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_transactionRecordWithCityID:(NSString *)cityID
                                                                      cardID:(NSString *)cardID
                                                                        type:(HMServiceBUSCardsTransactionRecordType)type
                                                                    nextTime:(NSDate * _Nullable)nextTime
                                                                       limit:(NSInteger)limit
                                                             completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsTransactionRecord>> * _Nullable records, NSDate *  _Nullable nestTime))completionBlock;

/**
 *  @brief  上传交易记录
 *
 *  @param  cityID          城市ID
 *
 *  @param  cardID          卡ID
 *
 *  @param  records         交易信息
 *
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_uploadTransactionRecordWithCityID:(NSString *)cityID
                                                                            cardID:(NSString *)cardID
                                                                           records:(NSArray<id<HMServiceAPIBUSCardsTransactionRecord>> *)records
                                                                   completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;

/**
 *  @brief  获取短信验证码
 *
 *  @param  phone           手机号
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_verifyCaptchaWithPhone:(NSString *)phone
                                                        completionBlock:(void (^)(BOOL success, NSInteger httpCode, NSString * _Nullable message))completionBlock;

/**
 *  @brief  绑定手机
 *
 *  @param  phone           手机号
 *
 *  @param  verifyCaptcha   验证码
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_boundPhone:(NSString *)phone
                                              verifyCaptcha:(NSString *)verifyCaptcha
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message))completionBlock;


/**
 *  @brief  获取固定的城市列表
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_citysWithCompletionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable citys))completionBlock;


/**
 *  @brief  获取固定的城市详情
 *
 *  @param  cityID          城市ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_cityWithID:(NSString *)cityID
                                            completionBlock:(void (^)(BOOL success, NSString * _Nullable message, id<HMServiceAPIBUSCardCity> _Nullable city))completionBlock;

/**
 *  @brief  获取已开通卡片城市列表
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_openedCitiesWithDeviceID:(NSString *)deviceID
                                                          completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardCity>> * _Nullable citys))completionBlock;

/**
 *  @brief  获取nfc设置信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    https://api-staging.private.mi-ae.net/swagger-ui.html#!/user45properties45controller/getUsingGET_54
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_retrieveWithCompletionBlock:(void (^)(BOOL success, NSString *message, id<HMServiceAPIWalletConfiguration> _Nullable configuration))completionBlock;


/**
 *  @brief  获取固定的城市详情
 *
 *  @param  deviceID        设备ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI> _Nullable)busCardsBinding_cityWithDeviceID:(NSString *)deviceID
                                                  completionBlock:(void (^)(BOOL success, NSString * _Nullable message, NSArray<id<HMServiceAPIBUSCardsCity>> * _Nullable cities))completionBlock;

@end


NS_ASSUME_NONNULL_END

@interface NSDictionary (HMServiceAPIBUSCardsCity) <HMServiceAPIBUSCardsCity>
@end


@interface HMServiceAPI (BUSCardsBinding) <HMServiceBUSCardsBindingAPI>
@end
