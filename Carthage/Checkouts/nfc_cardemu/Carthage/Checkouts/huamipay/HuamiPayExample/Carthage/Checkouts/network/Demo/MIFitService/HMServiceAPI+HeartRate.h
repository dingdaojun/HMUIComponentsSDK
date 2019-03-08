//
//  HMServiceAPI+HeartRate.h
//  HMNetworkLayer
//
//  Created by 李宪 on 26/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <HMService/HMService.h>

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=175
 PS: 由于现在跑步的心率数据走跑步的接口，所以这个接口只需要支持手动测量心率
 */
@protocol HMServiceAPIHeartRateData <NSObject>

@property (nonatomic, strong, readonly) NSDate *api_heartRateDataTime;
@property (nonatomic, assign, readonly) Byte api_heartRateDataValue;
@property (nonatomic, assign, readonly) HMServiceAPIDeviceSource api_heartRateDataDeviceSource;
@property (nonatomic, copy, readonly) NSString *api_heartRateDataDeviceID;

@end

@protocol HMServiceHeartRateAPI <HMServiceAPI>

/**
 上传心率数据
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/heart-rate-data-controller/postUsingPOST_8
 */
- (id<HMCancelableAPI>)heartRate_upload:(NSArray<id<HMServiceAPIHeartRateData>> *)items
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;


/**
 获取心率数据
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/heart-rate-data-controller/listUsingGET_4
 */
- (id<HMCancelableAPI>)heartRate_listWithDate:(NSDate *)date
                                        count:(NSInteger)count
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock;

/**
 获取心率数据
 @see http://device-service.private.mi-ae.cn/swagger-ui.html#!/heart-rate-data-controller/listUsingGET_4
 */
- (id<HMCancelableAPI>)heartRate_listWithDate:(NSDate *)date
                                        count:(NSInteger)count
                                   deviceType:(HMServiceAPIDeviceType)deviceType
                              completionBlock:(void (^)(BOOL success, NSString *message, NSArray<id<HMServiceAPIHeartRateData>> *heartRates))completionBlock;

/**
 删除心率数据
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=58
 */
- (id<HMCancelableAPI>)heartRate_delete:(NSArray<id<HMServiceAPIHeartRateData>> *)items
                        completionBlock:(void (^)(BOOL success, NSString *message))completionBlock;
@end

@interface HMServiceAPI (HeartRate) <HMServiceHeartRateAPI>
@end
