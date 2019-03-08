//  HMServiceAPI+Wallet.m
//  Created on 2018/3/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author shanjunlong(shanjunlong@huami.com)

#import "HMServiceAPI+Wallet.h"
#import <HMNetworkLayer/HMNetworkLayer.h>

static NSString *stringWithOrderCategory(HMServiceWalletOrderCategory category) {
    switch (category) {
        case HMServiceWalletOrderCategoryNormal: return @"normal";
        case HMServiceWalletOrderCategoryAbnormal: return @"abnormal";
        case HMServiceWalletOrderCategoryAll: return @"all";
    }
}

static NSString *stringWithPaymentChannel(HMServiceWalletOrderPaymentChannel channel) {
    switch (channel) {
        case HMServiceWalletOrderPaymentChannelWechat: return @"03";
        case HMServiceWalletOrderPaymentChannelAlipay: return @"07";
        case HMServiceWalletOrderPaymentChannelXiaoMi: return @"08";
        case HMServiceWalletOrderPaymentChannelTestAlipay: return @"50";
    }
}

static HMServiceWalletOrderPaymentChannel paymentChannelWithString(NSString *string) {
    NSDictionary *map = @{@"03" : @(HMServiceWalletOrderPaymentChannelWechat),
                          @"07" : @(HMServiceWalletOrderPaymentChannelAlipay),
                          @"08" : @(HMServiceWalletOrderPaymentChannelXiaoMi),
                          @"50" : @(HMServiceWalletOrderPaymentChannelTestAlipay)};
    return [map[string] integerValue];
}

static NSString *stringWithInstructionType(HMServiceWalletInstructionType channel) {
    switch (channel) {
        case HMServiceWalletInstructionTypeLoad: return @"load";
        case HMServiceWalletInstructionTypeIssuecard: return @"issuecard";
        case HMServiceWalletInstructionTypeTopup: return @"topup";
        case HMServiceWalletInstructionTypeIssueTopup: return @"issueTopup";
        case HMServiceWalletInstructionTypeLock: return @"lock";
        case HMServiceWalletInstructionTypeUnlock: return @"unlock";
        case HMServiceWalletInstructionTypeDeleteapp: return @"deleteapp";
        case HMServiceWalletInstructionTypeShiftout: return @"shiftout";
        case HMServiceWalletInstructionTypeShiftin: return @"shiftin";
        case HMServiceWalletInstructionTypeConfirmRecharge: return @"confirmRecharge";
        case HMServiceWalletInstructionTypeCopyFareCard: return @"copyFareCard";
    }
}

static HMServiceBUSCardCityStatus lingnanCityStatusWithString(NSString *string) {
    NSDictionary *map = @{@"PRE_ONLINE" : @(HMServiceBUSCardCityStatusPreOnline),
                          @"ONLINE" : @(HMServiceBUSCardCityStatusOnline),
                          @"TEST" : @(HMServiceBUSCardCityStatusTest),
                          @"OFFLINE" : @(HMServiceBUSCardCityStatusOffline),
                          @"DELETE" : @(HMServiceBUSCardCityStatusDelete)};
    return [map[string] integerValue];
}

@interface NSDictionary (HMServiceAPIWalletOrderFeeProtocol) <HMServiceAPIWalletOrderFeeProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletOrderFeeProtocol)

- (NSString *)api_walletOrderFeeID {
    return self.hmjson[@"fee_id"].string;
}

- (NSInteger)api_walletOrderFeeOpenCard {
    return self.hmjson[@"normal_card_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeShiftin {
    return self.hmjson[@"normal_shiftin_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeShiftout {
    return self.hmjson[@"normal_shiftout_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeRecharges {
    return self.hmjson[@"normal_topup_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeDiscountedOpenCard {
    return self.hmjson[@"promotion_card_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeDiscountedShiftin {
    return self.hmjson[@"promotion_shiftin_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeDiscountedShiftout {
    return self.hmjson[@"promotion_shiftout_fee"].integerValue;
}

- (NSInteger)api_walletOrderFeeDiscountedRecharges {
    return self.hmjson[@"promotion_topup_fee"].integerValue;
}

@end

@interface NSDictionary (HMServiceAPIWalletOrderProtocol) <HMServiceAPIWalletOrderProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletOrderProtocol)

- (NSString *)api_walletOrderID {
    return self.hmjson[@"snb_order_no"].string;
}

- (NSDate *)api_walletOrderExpire {
    return self.hmjson[@"order_expire_timestamp"].date;
}

- (NSString *)api_walletOrderSignedData {
    return self.hmjson[@"signed_data"].string;
}

- (NSString *)api_walletOrderSource {
    return self.hmjson[@"order_source"].string;
}

- (NSString *)api_walletOrderPayGateway {
    return self.hmjson[@"pay_gateway"].string;
}

- (NSString *)api_walletOrderPayUrl {
    return self.hmjson[@"pay_url"].string;
}

- (NSString *)api_walletOrderUrl {
    return self.hmjson[@"return_url"].string;
}

@end


@interface NSDictionary (HMServiceAPIWalletOrderDetailProtocol) <HMServiceAPIWalletOrderDetailProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletOrderDetailProtocol)

- (NSString *)api_walletOrderDetailID {
    return self.hmjson[@"snb_order_no"].string;
}

- (HMServiceWalletOrderPaymentChannel)api_walletOrderDetailPaymentChannel {
    return paymentChannelWithString(self.hmjson[@"payment_channel"].string);
}

- (HMServiceWalletOrderType)api_walletOrderDetailType {
    return self.hmjson[@"order_type"].integerValue;
}

- (HMServiceWalletOrderStatus)api_walletOrderDetailStatus {
    return self.hmjson[@"order_status"].integerValue;
}


- (NSString *)api_walletOrderDetailStatusDescription {
    return self.hmjson[@"order_status_desc"].string;
}

- (NSInteger)api_walletOrderDetailAmount {
    return self.hmjson[@"order_amount"].integerValue;
}

- (NSDate *)api_walletOrderDetailTime {
    return self.hmjson[@"order_time_timestamp"].date;
}

- (NSString *)api_walletOrderDetailSerialNumber {
    return self.hmjson[@"trans_no"].string;
}

- (NSString *)api_walletOrderDetailCityID {
    return self.hmjson[@"app_code"].string?:@"";
}


- (NSString *)api_walletOrderDetailXiaomiCityID {
    return self.hmjson[@"city_id"].string;
}

- (NSArray *)api_walletOrderDetailActionToken {
    return self.hmjson[@"actionToken"].array;
}

- (NSString *)api_walletOrderDetailOrderID {
    return self.hmjson[@"order_id"].string;
}

- (NSString *)api_walletOrderDetailOrderSource {
    return self.hmjson[@"order_source"].string;
}

- (NSDate *)api_walletOrderDetailPayTime {
    return self.hmjson[@"pay_time_timestamp"].date;
}

- (NSString *)api_walletOrderDetailXiamiCardName {
    return self.hmjson[@"xm_card_name"].string;
}

@end

@interface NSDictionary (HMServiceAPIWalletOrderAPDUProtocol) <HMServiceAPIWalletOrderAPDUProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletOrderAPDUProtocol)

- (NSString *)api_walletOrderAPDUSession {
    return self.hmjson[@"session"].string;
}

- (NSString *)api_walletOrderAPDUNextStep {
    return self.hmjson[@"next_step"].string;
}

- (NSArray *)api_walletOrderAPDUCommands {
    return self.hmjson[@"commands"].array;
}

@end


@interface NSDictionary (HMServiceAPIWalletOrderAPDUCommandProtocol) <HMServiceAPIWalletOrderAPDUCommandProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletOrderAPDUCommandProtocol)

- (NSString *)api_walletOrderAPDUIndex {
    return self.hmjson[@"index"].string;
}

- (NSString *)api_walletOrderAPDUCommand {
    return self.hmjson[@"command"].string;
}

- (NSString *)api_walletOrderAPDUCheckCode {
    return self.hmjson[@"checker"].string;
}

- (NSString *)api_walletOrderAPDUResult {
    return self.hmjson[@"snb_order_no"].string;
}

@end


@interface NSDictionary (HMServiceAPIWalletaAcessCardInfoProtocol) <HMServiceAPIWalletaAcessCardInfoProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletaAcessCardInfoProtocol)

- (NSString *)api_walletAcessCardInfoAid {
    return self.hmjson[@"aid"].string;
}

- (NSString *)api_walletAcessCardInfoCardArt {
    return self.hmjson[@"cardArt"].string;
}

- (NSInteger)api_walletAcessCardInfoCardType {
    return self.hmjson[@"cardType"].integerValue;
}

- (NSInteger)api_walletAcessCardInfoFingerFlag {
    return self.hmjson[@"fingerFlag"].integerValue;
}

- (NSString *)api_walletAcessCardInfoName {
    return [self.hmjson[@"name"].string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)api_walletAcessCardInfoUserTerms {
    return self.hmjson[@"userTerms"].string;
}

- (NSInteger)api_walletAcessCardInfoVSStatus {
    return self.hmjson[@"vcStatus"].integerValue;
}

@end


@interface NSDictionary (HMServiceAPIWalletLingnanCardCityProtocol) <HMServiceAPIWalletLingnanCardCityProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletLingnanCardCityProtocol)

- (NSString *)api_walletLingnanCardCityID {
    return self.hmjson[@"appCode"].string;
}

- (NSString *)api_walletLingnanCardCityName {
    return self.hmjson[@"cityName"].string;
}

- (NSString *)api_walletLingnanCardAID {
    return self.hmjson[@"aid"].string;
}

- (NSString *)api_walletLingnanCardName {
    return self.hmjson[@"cardName"].string;
}

- (BOOL)api_walletLingnanCardHasSubCity {
    return self.hmjson[@"hasSubCity"].boolean;
}

- (NSString *)api_walletLingnanCardOpenedImgUrl {
    return self.hmjson[@"openedImgUrl"].string;
}

- (NSString *)api_walletLingnanCardParentAppCode{
    return self.hmjson[@"parentAppCode"].string;
}

- (NSString *)api_walletLingnanCardServiceScope {
    return self.hmjson[@"serviceScope"].string;
}

- (HMServiceBUSCardCityStatus)api_walletLingnanCardStatus {
    return lingnanCityStatusWithString(self.hmjson[@"status"].string);
}

- (NSArray<NSString *> *)api_walletLingnanCardSupportApps {
    return self.hmjson[@"supportApps"].array;
}

- (NSString *)api_walletLingnanCardUnopenedImgUrl {
    return self.hmjson[@"unopenedImgUrl"].string;
}

- (NSString *)api_walletLingnanCardVisibleGroups {
    return self.hmjson[@"visibleGroups"].string;
}

- (NSString *)api_walletLingnanCardXiaomiCardName {
    return self.hmjson[@"xiaomiCardName"].string;
}

@end

@interface NSDictionary (HMServiceAPIWalletLingnanCardsProtocol) <HMServiceAPIWalletLingnanCardsProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletLingnanCardsProtocol)

- (id<HMServiceAPIWalletLingnanCardCityProtocol>)api_walletLingnanCardsRecommendedCity {
    return self.hmjson[@"recommended_city"].dictionary;
}

- (NSArray<id<HMServiceAPIWalletLingnanCardCityProtocol>> *)api_walletLingnanCardsAvailabledCitys {
    return self.hmjson[@"available_city"].array;
}

@end


@interface NSDictionary (HMServiceAPIWalletProtocol) <HMServiceAPIWalletProtocol>
@end

@implementation NSDictionary (HMServiceAPIWalletProtocol)

- (NSString *)api_walletProtocolContent {
    return self.hmjson[@"content"].string;
}

- (NSString *)api_walletProtocolID {
    return self.hmjson[@"id"].string;
}

- (NSString *)api_walletProtocolServiceName {
    return self.hmjson[@"serviceName"].string;
}

- (NSString *)api_walletProtocolTitle {
    return self.hmjson[@"title"].string;
}

- (BOOL)api_walletProtocolNeedConfirm {
    return self.hmjson[@"needConfirm"].boolean;
}

- (BOOL)api_walletProtocolUpdate {
    return self.hmjson[@"updated"].boolean;
}

@end


@implementation HMServiceAPI (Wallet)

- (id<HMCancelableAPI>)wallet_orderFeeWithCityID:(NSString *)cityID
                                       orderType:(HMServiceWalletOrderType)orderType
                                  xiaomiCardName:(NSString *)xiaomiCardName
                                 completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderFeeProtocol>> *orderFees))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(orderType >= HMServiceWalletOrderTypeOpenCard &&
                      orderType <= HMServiceWalletOrderTypeOpenCardAndRecharge);
    if (orderType < HMServiceWalletOrderTypeOpenCard ||
        orderType > HMServiceWalletOrderTypeOpenCardAndRecharge) {
        completionBlock(nil, @"类型为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/order/transactionAmount"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"type" : @(orderType)} mutableCopy];

        if (xiaomiCardName.length > 0) {
            [parameters setObject:xiaomiCardName forKey:@"xm_card_name"];
        }

        if (cityID.length > 0) {
            [parameters setObject:cityID forKey:@"app_code"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSArray *data) {

                                         completionBlock(status, message, data);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_orderWithCityID:(NSString *)cityID
                                        feeID:(NSString *)feeID
                                    orderType:(HMServiceWalletOrderType)orderType
                               paymentChannel:(HMServiceWalletOrderPaymentChannel)paymentChannel
                                paymentAmount:(NSInteger)paymentAmount
                                      loction:(CLLocation *)loction
                              completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderProtocol>order))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(orderType >= HMServiceWalletOrderTypeOpenCard &&
                      orderType <= HMServiceWalletOrderTypeOpenCardAndRecharge);
    if (orderType < HMServiceWalletOrderTypeOpenCard ||
        orderType > HMServiceWalletOrderTypeOpenCardAndRecharge) {
        completionBlock(nil, @"类型为空", nil);
        return nil;
    }

    NSParameterAssert(paymentChannel >= HMServiceWalletOrderPaymentChannelWechat &&
                      paymentChannel <= HMServiceWalletOrderPaymentChannelTestAlipay);
    if (paymentChannel < HMServiceWalletOrderPaymentChannelWechat ||
        paymentChannel > HMServiceWalletOrderPaymentChannelTestAlipay) {

        completionBlock(nil, @"付款渠道不合法", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/orders"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"app_code" : cityID,
                                             @"payment_channel" : stringWithPaymentChannel(paymentChannel),
                                             @"payment_amount" : @(paymentAmount),
                                             @"order_type" : @(orderType)} mutableCopy];
        if (feeID.length > 0) {
            [parameters setObject:feeID forKey:@"feeId"];
        }

        if (cityID.length > 0) {
            [parameters setObject:cityID forKey:@"app_code"];
        }

        if (loction) {
            CLLocationCoordinate2D coordinate = loction.coordinate;
            [parameters setObject:@(coordinate.latitude) forKey:@"la"];
            [parameters setObject:@(coordinate.longitude) forKey:@"lo"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_orderListWithCityID:(NSString *)cityID
                                   xiaomiCardName:(NSString *)xiaomiCardName
                                        startDate:(NSDate *)startDate
                                          endDate:(NSDate *)endDate
                                            count:(NSInteger)count
                                    orderCategory:(HMServiceWalletOrderCategory)orderCategory
                                  completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletOrderDetailProtocol>> *orderDetails))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(orderCategory >= HMServiceWalletOrderCategoryNormal &&
                      orderCategory <= HMServiceWalletOrderCategoryAll);
    if (orderCategory < HMServiceWalletOrderCategoryNormal ||
        orderCategory > HMServiceWalletOrderCategoryAll) {
        completionBlock(nil, @"类型为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/orders"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSInteger startTime = (NSInteger)[startDate timeIntervalSince1970];
        NSInteger endTime = (NSInteger)[endDate timeIntervalSince1970];


        NSMutableDictionary *parameters = [@{@"start_time" : @(startTime),
                                             @"end_time" : @(endTime),
                                             @"order_category" : stringWithOrderCategory(orderCategory),
                                             @"count" : @(count)} mutableCopy];

        if (cityID.length > 0) {
            [parameters setObject:cityID forKey:@"app_code"];
        }

        if (xiaomiCardName.length > 0) {
            [parameters setObject:xiaomiCardName forKey:@"xm_card_name"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                         NSArray *orderDetails = data.hmjson[@"orders"].array;
                                         completionBlock(status, message, orderDetails);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_orderDetailWithOrderID:(NSString *)orderID
                                     completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderDetailProtocol>orderDetail))completionBlock {


    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(orderID.length > 0);
    if (orderID.length == 0) {
        completionBlock(nil, @"订单号为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *referenceURL = [NSString stringWithFormat:@"nfc/order/%@", orderID];
        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:referenceURL];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                         completionBlock(status, message, data);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_refundWithOrderID:(NSString *)orderID
                                completionBlock:(void (^)(NSString *status, NSString *message))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出");
        return nil;
    }

    NSParameterAssert(orderID.length > 0);
    if (orderID.length == 0) {
        completionBlock(nil, @"订单号为空");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/order/refund"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"snb_order_no" : orderID} mutableCopy];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_APDUWithOrderID:(NSString *)orderID
                                       cityID:(NSString *)cityID
                              instructionType:(HMServiceWalletInstructionType)instructionType
                                 extendedInfo:(NSString *)extendedInfo
                              completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDU))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/script/init"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"app_code" : cityID,
                                             @"action_type" : stringWithInstructionType(instructionType)} mutableCopy];

        if (orderID.length > 0) {
            [parameters setObject:orderID forKey:@"snb_order_no"];
        }

        if (extendedInfo.length > 0) {
            [parameters setObject:extendedInfo forKey:@"extra_info"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (NSDictionary *)dictionaryWithAPDU:(id<HMServiceAPIWalletOrderRequestAPDUProtocol>)APDU {

    return  @{@"action_type" : stringWithInstructionType(APDU.api_walletOrderRequestAPDUType),
              @"aid" : APDU.api_walletOrderRequestAPDUAid,
              @"app_code" : APDU.api_walletOrderRequestAPDUCityID,
              @"balance" : APDU.api_walletOrderRequestAPDUBalance,
              @"card_number" : APDU.api_walletOrderRequestAPDUCardNumber,
              @"city_id" : APDU.api_walletOrderRequestAPDUXiaomiCityID,
              @"extra_info" : APDU.api_walletOrderRequestAPDUExtraInfo,
              @"fetch_adpu_mode" : APDU.api_walletOrderRequestAPDUFetchMode,
              @"order_token" : APDU.api_walletOrderRequestAPDUOrderToken,
              @"snb_order_no" : APDU.api_walletOrderRequestAPDUOrderID};
}

- (id<HMCancelableAPI>)wallet_APDUWithProtocol:(id<HMServiceAPIWalletOrderRequestAPDUProtocol>)APDU
                               completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDUResult))completionBlock {


    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(APDU);
    if (!APDU) {
        completionBlock(nil, @"没有APDU", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/script/init"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];


        NSDictionary *APDUDictionary = [self dictionaryWithAPDU:APDU];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:APDUDictionary];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_APDUWithResult:(id<HMServiceAPIWalletOrderAPDUProtocol>)result
                                        APDU:(id<HMServiceAPIWalletOrderRequestAPDUProtocol>)APDU
                                resultSucess:(BOOL)resultSucess
                             completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>APDU))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(result);
    NSParameterAssert(APDU);

    if (!result || !APDU) {
        completionBlock(nil, @"无上次返回的结果, 没有APDU", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/script/request"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSDictionary *APDUDictionary = [self dictionaryWithAPDU:APDU];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:APDUDictionary];

        NSMutableArray *resultDictionarys = [NSMutableArray array];
        NSArray *commands = result.api_walletOrderAPDUCommands;
        for (id<HMServiceAPIWalletOrderAPDUCommandProtocol> command in commands) {

            NSMutableDictionary *resultDictionary = [@{@"index" : command.api_walletOrderAPDUIndex?:@"",
                                                       @"command" : command.api_walletOrderAPDUCommand?:@"",
                                                       @"result" : command.api_walletOrderAPDUResult?:@"",
                                                       } mutableCopy];
            NSString *check = command.api_walletOrderAPDUCheckCode;
            if (check.length != 0) {
                [resultDictionary setObject:check forKey:@"checker"];
            }
            [resultDictionarys addObject:resultDictionary];
        }

        NSDictionary *commandResults = @{@"succeed" : @(resultSucess),
                                         @"results" : resultDictionarys};
        [parameters setObject:result.api_walletOrderAPDUSession forKey:@"session"];
        [parameters setObject:commandResults forKey:@"command_results"];

        NSString *nextStep = result.api_walletOrderAPDUNextStep;
        if (nextStep.length > 0) {
            [parameters setObject:nextStep forKey:@"current_step"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_lingnanCardsWithCoordination:(CLLocationCoordinate2D)coordinate
                                               phoneNumber:(NSString *)phoneNumber
                                                    userIP:(NSString *)userIP
                                           completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletLingnanCardsProtocol> cards))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/cards/city"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"longitude" : @(coordinate.longitude),
                                             @"latitude" : @(coordinate.latitude)} mutableCopy];

        if (phoneNumber.length != 0) {
            [parameters setObject:phoneNumber forKey:@"phone_number"];
        }
        if (userIP.length != 0) {
            [parameters setObject:userIP forKey:@"user_ip"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_installedCardsWithCompletionBlock:(void (^)(NSString *status, NSString *message, NSArray<NSString *> *applicationIDs))completionBlock {


    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);

    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }
    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/cards/installed"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                         completionBlock(status, message, data.hmjson[@"aids"].array);
                                     }];
                  }];
    }];
}


- (id<HMCancelableAPI>)wallet_cardIDWithCityID:(NSString *)cityID
                                           aid:(NSString *)aid
                                    cardNumber:(NSString *)cardNumber
                               completionBlock:(void (^)(NSString *status, NSString *message, NSString *cardID))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(cityID.length > 0);
    if (cityID.length == 0) {
        completionBlock(nil, @"公交应用 cityID为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/cards/no"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"app_code" : cityID} mutableCopy];
        if (aid.length > 0) {
            [parameters setObject:aid forKey:@"aid"];
        }
        if (cardNumber.length > 0) {
            [parameters setObject:cardNumber forKey:@"cardNo"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          NSString *cardID = data.hmjson[@"card_no"].string;
                                          completionBlock(status, message, cardID);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_protocolWithXiaomiCardName:(NSString *)xiaomiCardName
                                             acctionType:(NSString *)acctionType
                                         completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletProtocol> protocol))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(acctionType.length > 0);
    if (acctionType.length == 0) {
        completionBlock(nil, @"acctionType为空", nil);
        return nil;
    }


    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/protocol"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [@{@"action_type" : acctionType} mutableCopy];
        if (xiaomiCardName.length > 0) {
            [parameters setObject:xiaomiCardName forKey:@"xm_card_name"];
        }

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                         completionBlock(status, message, data);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_confirmProtocolWithID:(NSString *)ID
                                    completionBlock:(void (^)(NSString *status, NSString *message))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出");
        return nil;
    }

    NSParameterAssert(ID.length > 0);
    if (ID.length == 0) {
        completionBlock(nil, @"没有协议的ID");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/protocol"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"id" : ID} mutableCopy];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatHTTP
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message);
                                      }];
                   }];
    }];
}


- (id<HMCancelableAPI>)wallet_cacessCard:(id<HMServiceAPIWalletaAcessCardProtocol>)acessCard
                         completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>result))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(acessCard);
    if (!acessCard) {
        completionBlock(nil, @"门禁信息为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/accessCard/script/init"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        
        NSMutableDictionary *parameters = [@{@"action_type" : stringWithInstructionType(acessCard.api_walletOrderRequestAPDUType),
                                             @"aid" : acessCard.api_walletOrderRequestAPDUAid,
                                             @"atqa" : acessCard.api_walletAcessCardAtqa,
                                             @"blockContent" : acessCard.api_walletAcessCardBlockContent,
                                             @"fareCardType" : @(acessCard.api_walletAcessCardFareCardType),
                                             @"fetch_adpu_mode" : acessCard.api_walletOrderRequestAPDUFetchMode,
                                             @"sak" : acessCard.api_walletAcessCardSak,
                                             @"size" : @(acessCard.api_walletAcessCardSize),
                                             @"uid" : acessCard.api_walletAcessCardUid} mutableCopy];

        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_nextStepCacessCard:(id<HMServiceAPIWalletaAcessCardProtocol>)acessCard
                                          result:(id<HMServiceAPIWalletOrderAPDUProtocol>)result
                                    resultSucess:(BOOL)resultSucess
                                 completionBlock:(void (^)(NSString *status, NSString *message, id<HMServiceAPIWalletOrderAPDUProtocol>resul))completionBlock {

    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(acessCard);
    NSParameterAssert(result);
    if (!acessCard || !result) {
        completionBlock(nil, @"门禁信息为空", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/accessCard/script/request"];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSMutableDictionary *parameters = [@{@"action_type" : stringWithInstructionType(acessCard.api_walletOrderRequestAPDUType),
                                             @"aid" : acessCard.api_walletOrderRequestAPDUAid,
                                             @"atqa" : acessCard.api_walletAcessCardAtqa,
                                             @"blockContent" : acessCard.api_walletAcessCardBlockContent,
                                             @"fareCardType" : @(acessCard.api_walletAcessCardFareCardType),
                                             @"fetch_adpu_mode" : acessCard.api_walletOrderRequestAPDUFetchMode,
                                             @"sak" : acessCard.api_walletAcessCardSak,
                                             @"size" : @(acessCard.api_walletAcessCardSize),
                                             @"uid" : acessCard.api_walletAcessCardUid} mutableCopy];
        NSMutableArray *resultDictionarys = [NSMutableArray array];
        NSArray *commands = result.api_walletOrderAPDUCommands;
        for (id<HMServiceAPIWalletOrderAPDUCommandProtocol> command in commands) {

            NSMutableDictionary *resultDictionary = [@{@"index" : command.api_walletOrderAPDUIndex?:@"",
                                                       @"command" : command.api_walletOrderAPDUCommand?:@"",
                                                       @"result" : command.api_walletOrderAPDUResult?:@"",
                                                       } mutableCopy];
            NSString *check = command.api_walletOrderAPDUCheckCode;
            if (check.length != 0) {
                [resultDictionary setObject:check forKey:@"checker"];
            }
            [resultDictionarys addObject:resultDictionary];
        }

        NSDictionary *commandResults = @{@"succeed" : @(resultSucess),
                                         @"results" : resultDictionarys};
        [parameters setObject:result.api_walletOrderAPDUSession forKey:@"session"];
        [parameters setObject:commandResults forKey:@"command_results"];

        NSString *nextStep = result.api_walletOrderAPDUNextStep;
        if (nextStep.length > 0) {
            [parameters setObject:nextStep forKey:@"current_step"];
        }



        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message, data);
                                      }];
                   }];
    }];
}

- (id<HMCancelableAPI>)wallet_acessCardWithSessionID:(NSString *)sessionID
                                     completionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    NSParameterAssert(sessionID.length > 0);
    if (sessionID.length == 0) {
        completionBlock(nil, @"sessionID为空", nil);
        return nil;
    }


    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/accessCard/info"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [@{@"sessionId" : sessionID} mutableCopy];
        
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSArray *data) {

                                         completionBlock(status, message, data);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_acessCardWithCompletionBlock:(void (^)(NSString *status, NSString *message, NSArray<id<HMServiceAPIWalletaAcessCardInfoProtocol>> *infos))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出", nil);
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/accessCard/list"];

        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[self.delegate uniformParametersForService:self error:&error]];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription, nil);
            });
            return nil;
        }

        return [HMNetworkCore GET:URL
                       parameters:parameters
                          headers:headers
                          timeout:0
               responseDataFormat:HMNetworkResponseDataFormatJSON
                  completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                      [self walletHandleResultForAPI:_cmd
                                       responseError:error
                                            response:response
                                      responseObject:responseObject
                                     completionBlock:^(NSString *status, NSString *message, NSArray *data) {

                                         completionBlock(status, message, data);
                                     }];
                  }];
    }];
}

- (id<HMCancelableAPI>)wallet_updateAcessCard:(id<HMServiceAPIWalletaAcessCardInfoProtocol>)card
                              completionBlock:(void (^)(NSString *status, NSString *message))completionBlock {


    if (!completionBlock) {
        return nil;
    }

    NSString *userID = [self.delegate userIDForService:self];
    NSParameterAssert(userID.length > 0);
    if (userID.length == 0) {
        completionBlock(nil, @"账号已经退出");
        return nil;
    }

    return [HMServiceAPITask taskWithConcreteBlock:^NSURLSessionTask *{

        NSString *URL = [self.delegate absoluteURLForService:self referenceURL:@"nfc/accessCard/info"];
        NSError *error = nil;
        NSDictionary *otherHeaders = [self.delegate uniformHeaderFieldValuesForService:self error:&error];
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }
        NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:otherHeaders];
        [headers addEntriesFromDictionary:[self.delegate uniformWalletHeaderFieldValues]];

        NSString *name = card.api_walletAcessCardInfoName;
        NSMutableDictionary *parameters = [@{@"aid" : card.api_walletAcessCardInfoAid,
                                             @"cardArt" : card.api_walletAcessCardInfoCardArt,
                                             @"cardType" : @(card.api_walletAcessCardInfoCardType),
                                             @"fingerFlag" : @(card.api_walletAcessCardInfoFingerFlag),
                                             @"name" : name ? [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]: @"",
                                             @"userTerms" : card.api_walletAcessCardInfoUserTerms,
                                             @"vcStatus" : @(card.api_walletAcessCardInfoVSStatus)} mutableCopy];

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error.localizedDescription);
            });
            return nil;
        }

        return [HMNetworkCore POST:URL
                        parameters:parameters
                           headers:headers
                           timeout:0
                 requestDataFormat:HMNetworkRequestDataFormatJSON
                responseDataFormat:HMNetworkResponseDataFormatJSON
                   completionBlock:^(NSError *error, NSURLResponse *response, id responseObject) {

                       [self walletHandleResultForAPI:_cmd
                                        responseError:error
                                             response:response
                                       responseObject:responseObject
                                      completionBlock:^(NSString *status, NSString *message, NSDictionary *data) {

                                          completionBlock(status, message);
                                      }];
                   }];
    }];
}

@end
