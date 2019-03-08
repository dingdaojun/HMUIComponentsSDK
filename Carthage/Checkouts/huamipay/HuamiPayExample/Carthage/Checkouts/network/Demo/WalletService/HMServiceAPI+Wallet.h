//  HMServiceAPI+Wallet.h
//  Created on 2018/3/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import <HMService/HMService.h>
#import <CoreLocation/CoreLocation.h>
#import "HMServiceAPI+WalletHandleResult.h"
#import "HMServiceAPI+BUSCardsBinding.h"
#import "HMServiceAPI+BUSCard.h"

typedef NS_ENUM(NSUInteger, HMServiceWalletOrderType) {

    HMServiceWalletOrderTypeOpenCard                = 1,        // 开卡
    HMServiceWalletOrderTypeRecharge                = 2,        // 充值（圈存）
    HMServiceWalletOrderTypeOpenCardAndRecharge     = 3,        // 开卡并充值
};

typedef NS_ENUM(NSUInteger, HMServiceWalletOrderStatus) {
    HMServiceWalletOrderStatusSucess                                = 0,        // 成功
    HMServiceWalletOrderStatusNew                                   = 1000,     // 新建(订单号已生成)
    HMServiceWalletOrderStatusDeductionFailed                       = 1003,     // 扣款失败
    HMServiceWalletOrderStatusDeductionSucessAndUnprocessed         = 1006,     // 扣款成功,未处理
    HMServiceWalletOrderStatusDeductionSucessAndOpenCardFailed      = 1001,     // 扣款成功,开卡失败
    HMServiceWalletOrderStatusDeductionSucessAndRechargeFailed      = 1002,     // 扣款成功,圈存失败
    HMServiceWalletOrderStatusDeductionSucessAndRefunding           = 1004,     // 扣款成功,退款中
    HMServiceWalletOrderStatusDeductionSucessAndRefundFailed        = 1005,     // 扣款成功,退款失败
    HMServiceWalletOrderStatusRefundSucess                          = 1008,     // 退款成功
    HMServiceWalletOrderStatusDeductionSucessAndRechargeConfirmed   = 1007,     // 扣款成功,圈存状态待确认(客户端需重试圈存)
    HMServiceWalletOrderStatusDeductionSucessAndRechargeDoubt       = 1009,     // 扣款成功,圈存存疑,需跟通卡确认(开始走人 工流程)
};

typedef NS_ENUM(NSUInteger, HMServiceWalletOrderPaymentChannel) {
    HMServiceWalletOrderPaymentChannelWechat,           // 微信
    HMServiceWalletOrderPaymentChannelAlipay,           // 支付宝
    HMServiceWalletOrderPaymentChannelXiaoMi,           // 小米
    HMServiceWalletOrderPaymentChannelTestAlipay,       // 测试支付宝
};

typedef NS_ENUM(NSUInteger, HMServiceWalletOrderCategory) {
    HMServiceWalletOrderCategoryNormal,             // 正常
    HMServiceWalletOrderCategoryAbnormal,           // 异常
    HMServiceWalletOrderCategoryAll,                // 所有
};


typedef NS_ENUM(NSUInteger, HMServiceWalletInstructionType) {
    HMServiceWalletInstructionTypeLoad,                 // 只下载 cap
    HMServiceWalletInstructionTypeIssuecard ,           // 下载 Cap+Perso
    HMServiceWalletInstructionTypeTopup ,               // 圈存
    HMServiceWalletInstructionTypeIssueTopup,           // 开卡+圈存
    HMServiceWalletInstructionTypeLock,                 // 锁定
    HMServiceWalletInstructionTypeUnlock,               // 解锁
    HMServiceWalletInstructionTypeDeleteapp,            // 删除卡片
    HMServiceWalletInstructionTypeShiftout,             // 移资删老卡
    HMServiceWalletInstructionTypeShiftin,              // 移资开新卡
    HMServiceWalletInstructionTypeConfirmRecharge,      // 圈存确认
    HMServiceWalletInstructionTypeCopyFareCard,
};

@protocol HMServiceAPIWalletOrderFeeProtocol <NSObject>

@property (readonly) NSString *api_walletOrderFeeID;                    // 费用的ID
@property (readonly) NSInteger api_walletOrderFeeOpenCard;              // 正常的卡费用
@property (readonly) NSInteger api_walletOrderFeeShiftin;               // 正常的迁入卡费用
@property (readonly) NSInteger api_walletOrderFeeShiftout;              // 正常的迁出卡费用
@property (readonly) NSInteger api_walletOrderFeeRecharges;             // 正常的充值
@property (readonly) NSInteger api_walletOrderFeeDiscountedOpenCard;    // 优惠的卡费用
@property (readonly) NSInteger api_walletOrderFeeDiscountedShiftin;     // 优惠的迁入卡费用
@property (readonly) NSInteger api_walletOrderFeeDiscountedShiftout;    // 优惠的迁出卡费用
@property (readonly) NSInteger api_walletOrderFeeDiscountedRecharges;   // 优惠的充值

@end

@protocol HMServiceAPIWalletOrderProtocol <NSObject>

@property (readonly) NSString *api_walletOrderID;                       // 订单ID
@property (readonly) NSDate *api_walletOrderExpire;                     // 订单有效期
@property (readonly) NSString *api_walletOrderSignedData;               // 支付sdk用
@property (readonly) NSString *api_walletOrderSource;                   // 支付来源
@property (readonly) NSString *api_walletOrderPayGateway;               // 支付Gateway
@property (readonly) NSString *api_walletOrderPayUrl;                   // 支付url
@property (readonly) NSString *api_walletOrderUrl;                      // url

@end

@protocol HMServiceAPIWalletOrderDetailProtocol <NSObject>

@property (readonly) NSString *api_walletOrderDetailID;                                     // 订单ID
@property (readonly) HMServiceWalletOrderPaymentChannel api_walletOrderDetailPaymentChannel;// 支付渠道
@property (readonly) HMServiceWalletOrderType api_walletOrderDetailType;                    // 交易类型
@property (readonly) HMServiceWalletOrderStatus api_walletOrderDetailStatus;                // 订单状态
@property (readonly) NSString *api_walletOrderDetailStatusDescription;                      // 订单状态描述
@property (readonly) NSInteger  api_walletOrderDetailAmount;                                // 交易金额
@property (readonly) NSDate  *api_walletOrderDetailTime;                                    // 订单时间
@property (readonly) NSString *api_walletOrderDetailSerialNumber;                           // 支付流水号
@property (readonly) NSString *api_walletOrderDetailCityID;                                 // 城市信息
@property (readonly) NSString *api_walletOrderDetailXiaomiCityID;                           // 小米城市信息
@property (readonly) NSArray *api_walletOrderDetailActionToken;                             // ActionToken
@property (readonly) NSString *api_walletOrderDetailOrderID;                                //
@property (readonly) NSString *api_walletOrderDetailOrderSource;                            // 付款来源
@property (readonly) NSDate *api_walletOrderDetailPayTime;                                  // 付款时间
@property (readonly) NSString *api_walletOrderDetailXiamiCardName;                          // 小米卡片名称

@end

@protocol HMServiceAPIWalletOrderAPDUCommandProtocol <NSObject>

@property (readonly) NSString *api_walletOrderAPDUIndex;                                     // 指令序号
@property (readonly) NSString *api_walletOrderAPDUCommand;                                   // 指令
@property (readonly) NSString *api_walletOrderAPDUCheckCode;                                 // 期望结果正则表达式
@property (readonly) NSString *api_walletOrderAPDUResult;                                    // 指令执行结果          服务器返回的结果中没有这项

@end

@protocol HMServiceAPIWalletOrderAPDUProtocol <NSObject>

@property (readonly) NSString *api_walletOrderAPDUSession;                                  // 会话
@property (readonly) NSString *api_walletOrderAPDUNextStep;                                 // 下一步
@property (readonly) NSArray<id<HMServiceAPIWalletOrderAPDUCommandProtocol>> *api_walletOrderAPDUCommands;  // 指令

@end

@protocol HMServiceAPIWalletLingnanCardCityProtocol <NSObject>

@property (readonly) NSString *api_walletLingnanCardCityID;
@property (readonly) NSString *api_walletLingnanCardCityName;
@property (readonly) NSString *api_walletLingnanCardAID;
@property (readonly) NSString *api_walletLingnanCardName;
@property (readonly) BOOL api_walletLingnanCardHasSubCity;
@property (readonly) NSString *api_walletLingnanCardOpenedImgUrl;
@property (readonly) NSString *api_walletLingnanCardParentAppCode;
@property (readonly) NSString *api_walletLingnanCardServiceScope;
@property (readonly) HMServiceBUSCardCityStatus api_walletLingnanCardStatus;
@property (readonly) NSArray<NSString *> *api_walletLingnanCardSupportApps;
@property (readonly) NSString *api_walletLingnanCardUnopenedImgUrl;
@property (readonly) NSString *api_walletLingnanCardVisibleGroups;
@property (readonly) NSString *api_walletLingnanCardXiaomiCardName;

@end

@protocol HMServiceAPIWalletLingnanCardsProtocol <NSObject>

@property (readonly) id<HMServiceAPIWalletLingnanCardCityProtocol> api_walletLingnanCardsRecommendedCity;              // 推荐的城市
@property (readonly) NSArray<id<HMServiceAPIWalletLingnanCardCityProtocol>> *api_walletLingnanCardsAvailabledCitys;     // 可用的城市列表

@end


@protocol HMServiceAPIWalletOrderRequestAPDUProtocol <NSObject>

@property (readonly) NSString *api_walletOrderRequestAPDUAid;                                       // 应用ID
@property (readonly) NSString *api_walletOrderRequestAPDUBalance;
@property (readonly) NSString *api_walletOrderRequestAPDUCityID;                                    // 城市ID
@property (readonly) NSString *api_walletOrderRequestAPDUCardNumber;
@property (readonly) NSString *api_walletOrderRequestAPDUXiaomiCityID;
@property (readonly) NSString *api_walletOrderRequestAPDUExtraInfo;
@property (readonly) NSString *api_walletOrderRequestAPDUFetchMode;
@property (readonly) NSString *api_walletOrderRequestAPDUOrderToken;
@property (readonly) NSString *api_walletOrderRequestAPDUOrderID;
@property (readonly) HMServiceWalletInstructionType api_walletOrderRequestAPDUType;                 // apdu的类型

@end


@protocol HMServiceAPIWalletProtocol <NSObject>

@property (readonly) NSString *api_walletProtocolContent;                       // 协议的内容
@property (readonly) NSString *api_walletProtocolID;                            // 协议的ID
@property (readonly) BOOL api_walletProtocolNeedConfirm;                        // 是否确定
@property (readonly) NSString *api_walletProtocolServiceName;                   // 服务器名称
@property (readonly) NSString *api_walletProtocolTitle;                         // 协议的名称
@property (readonly) BOOL api_walletProtocolUpdate;                             // 协议是否更新

@end

@protocol HMServiceAPIWalletaAcessCardProtocol <HMServiceAPIWalletOrderRequestAPDUProtocol>

@property (readonly) NSString *api_walletAcessCardAtqa;
@property (readonly) NSString *api_walletAcessCardBlockContent;
@property (readonly) NSString *api_walletAcessCardSak;
@property (readonly) NSString *api_walletAcessCardUid;
@property (readonly) NSInteger api_walletAcessCardSize;
@property (readonly) NSInteger api_walletAcessCardFareCardType;

@end

@protocol HMServiceAPIWalletaAcessCardInfoProtocol <NSObject>

@property (readonly) NSString *api_walletAcessCardInfoAid;
@property (readonly) NSString *api_walletAcessCardInfoCardArt;
@property (readonly) NSInteger api_walletAcessCardInfoCardType;
@property (readonly) NSInteger api_walletAcessCardInfoFingerFlag;
@property (readonly) NSString *api_walletAcessCardInfoName;
@property (readonly) NSString *api_walletAcessCardInfoUserTerms;
@property (readonly) NSInteger api_walletAcessCardInfoVSStatus;

@end

@protocol HMServiceWalletAPI <HMServiceAPI>

/**
 *  @brief  据交易类型获取相关费用 (获取费用)
 *
 *  @param  cityID          城市的标识符（app_code）
 *
 *  @param  orderType       订单类型
 *
 *  @param  xiaomiCardName  小米的卡名称
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    https://huami.sharepoint.cn/:w:/r/sites/teams/bnd/_layouts/15/WopiFrame.aspx?sourcedoc=%7B2A56007E-D927-448B-B876-418B90A97444%7D&file=NFC%E5%85%AC%E4%BA%A4%E5%8D%A1%E6%9C%8D%E5%8A%A1%E7%AB%AFAPI%E6%96%87%E6%A1%A3.docx&action=default
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_orderFeeWithCityID:(NSString *)cityID
                                       orderType:(HMServiceWalletOrderType)orderType
                                  xiaomiCardName:(NSString *)xiaomiCardName
                                 completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderFeeProtocol>> *orderFees))completionBlock;

/**
 *  @brief  生成订单号 (获取订单号)
 *
 *  @param  cityID          城市的标识符（雪球中的app_code）
 *
 *  @param  feeID           费用ID
 *
 *  @param  orderType       订单类型
 *
 *  @param  paymentChannel  订单付款渠道
 *
 *  @param  paymentAmount   实扣金额（分）
 *
 *  @param  loction         位置信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_orderWithCityID:(NSString *)cityID
                                        feeID:(NSString *)feeID
                                    orderType:(HMServiceWalletOrderType)orderType
                               paymentChannel:(HMServiceWalletOrderPaymentChannel)paymentChannel
                                paymentAmount:(NSInteger)paymentAmount
                                      loction:(CLLocation *)loction
                              completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderProtocol>order))completionBlock;

/**
 *  @brief  订单列表        （订单列表）
 *
 *  @param  cityID          城市的标识符（雪球中的app_code） defalut为nil即为所有城市
 *
 *  @param  xiaomiCardName  小米的卡片名称
 *
 *  @param  startDate       查询开始时间
 *
 *  @param  endDate         查询结束时间
 *
 *  @param  orderCategory   订单类型
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45bus45card45controller/getOrdersUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_orderListWithCityID:(NSString *)cityID
                                   xiaomiCardName:(NSString *)xiaomiCardName
                                        startDate:(NSDate *)startDate
                                          endDate:(NSDate *)endDate
                                            count:(NSInteger)count
                                    orderCategory:(HMServiceWalletOrderCategory)orderCategory
                                  completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderDetailProtocol>> *orderDetails))completionBlock;

/**
 *  @brief  订单详情
 *
 *  @param  orderID         订单号
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_orderDetailWithOrderID:(NSString *)orderID
                                     completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderDetailProtocol>orderDetail))completionBlock;

/**
 *  @brief  申请退款 （申请退款）
 *
 *  @param  orderID         订单号
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45bus45card45controller/refundUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_refundWithOrderID:(NSString *)orderID
                                completionBlock:(void (^)(NSString *status, NSString *message))completionBlock;

/**
 *  @brief  获取APDU指令
 *
 *  @param  APDU            APDU的参数
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_APDUWithProtocol:(id<HMServiceAPIWalletOrderRequestAPDUProtocol>)APDU
                               completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDUResult))completionBlock;

/**
 *  @brief  获取APDU指令
 *
 *  @param  result          上一次执行的结果
 *
 *  @param  APDU            APDU的参数
 *
 *  @param  resultSucess    上一次是否成功
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_APDUWithResult:(id<HMServiceAPIWalletOrderAPDUProtocol>)result
                                        APDU:(id<HMServiceAPIWalletOrderRequestAPDUProtocol>)APDU
                                resultSucess:(BOOL)resultSucess
                             completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDUResult))completionBlock;

/**
 *  @brief  查询卡列表(岭南通)
 *
 *  @param  coordinate      用户所在的经纬度
 *
 *  @param  phoneNumber     手机号(非必填)
 *
 *  @param  userIP          用户IP(非必填)
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_lingnanCardsWithCoordination:(CLLocationCoordinate2D)coordinate
                                               phoneNumber:(NSString *)phoneNumber
                                                    userIP:(NSString *)userIP
                                           completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletLingnanCardsProtocol> cards))completionBlock;

/**
 *  @brief  查询已安装卡列表(返回的是公交应用 aid)
 *
 *  @param  completionBlock 回调方法
 *
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_installedCardsWithCompletionBlock:(void (^)(NSString *status, NSString *message, NSArray<NSString *> *applicationIDs))completionBlock;

/**
 *  @brief  获取公交完整卡号（获取卡号）
 *
 *  @param  cityID      公交应用 cityID
 *
 *  @param  aid         应用 ID
 *
 *  @param  cardNumber  卡号
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45bus45card45controller/getCardNoUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_cardIDWithCityID:(NSString *)cityID
                                           aid:(NSString *)aid
                                    cardNumber:(NSString *)cardNumber
                               completionBlock:(void (^)(NSString *status, NSString *message, NSString *cardID))completionBlock;

/**
 *  @brief  获取协议
 *
 *  @param  xiaomiCardName  小米的卡名称
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging.private.mi-ae.net/swagger-ui.html#!/nfc45bus45card45controller/getProtocolsUsingGET
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_protocolWithXiaomiCardName:(NSString *)xiaomiCardName
                                             acctionType:(NSString *)acctionType
                                         completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletProtocol> protocol))completionBlock;

/**
 *  @brief  确认协议
 *
 *  @param  ID 协议ID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45bus45card45controller/getOrderNoUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_confirmProtocolWithID:(NSString *)ID
                                    completionBlock:(void (^)(NSString *status, NSString *message))completionBlock;

/**
 *  @brief  门禁卡
 *
 *  @param  acessCard 协议
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45access45card45controller/requestScriptUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_cacessCard:(id<HMServiceAPIWalletaAcessCardProtocol>)acessCard
                         completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>result))completionBlock;

/**
 *  @brief  门禁卡(下一步餐座)
 *
 *  @param  acessCard       协议
 *
 *  @param  result          上次执行结果
 *
 *  @param  resultSucess    是否成功
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45access45card45controller/requestScriptUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_nextStepCacessCard:(id<HMServiceAPIWalletaAcessCardProtocol>)acessCard
                                          result:(id<HMServiceAPIWalletOrderAPDUProtocol>)result
                                    resultSucess:(BOOL)resultSucess
                                 completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>resul))completionBlock;

/**
 *  @brief  门禁卡信息
 *
 *  @param  sessionID       sessionID
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45access45card45controller/requestScriptUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_acessCardWithSessionID:(NSString *)sessionID
                                     completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos))completionBlock;


/**
 *  @brief  门禁卡信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45access45card45controller/requestScriptUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_acessCardWithCompletionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos))completionBlock;



/**
 *  @brief  更新门禁卡信息
 *
 *  @param  completionBlock 回调方法
 *
 *  @see    http://mifit-device-service-staging-nfc.mi-ae.net/swagger-ui.html#!/nfc45access45card45controller/requestScriptUsingPOST
 *  @ower   单军龙
 */
- (id<HMCancelableAPI>)wallet_updateAcessCard:(id<HMServiceAPIWalletaAcessCardInfoProtocol>)card
                              completionBlock:(void (^)(NSString *status, NSString *message))completionBlock;

@end


@interface HMServiceAPI (Wallet) <HMServiceWalletAPI>




@end
