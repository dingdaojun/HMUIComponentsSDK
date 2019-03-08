//
//  NSArray+HMServiceAPIRunDetailEncode.h
//  HMNetworkLayer
//
//  Created by 单军龙 on 2017/6/21.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (HMServiceAPIRunDetailEncode)

/**
 *  @brief  经纬度编码
 */
- (NSString *)hm_stringByEncodingLongitudeAndLatitude;

/**
 *  @brief  GPS精准度编码
 */
- (NSString *)hm_stringByEncodingAccuracy;

/**
 *  @brief  海拔编码
 */
- (NSString *)hm_stringByEncodingAltitude;

/**
 *  @brief  用时编码
 */
- (NSString *)hm_stringByEncodingTimeWithStartTime:(NSTimeInterval)startTime;

/**
 *  @brief  步态编码
 */
- (NSString *)hm_stringByEncodingGaitWithStartTime:(NSTimeInterval)startTime;

/**
 *  @brief  配速编码
 */
- (NSString *)hm_stringByEncodingPace;

/**
 *  @brief  暂停编码
 */
- (NSString *)hm_stringByEncodingPause;

/**
 *  @brief  gps状态编码
 */
- (NSString *)hm_stringByEncodingFlag;

/**
 *  @brief  距离编码
 */
- (NSString *)hm_stringByEncodingDistanceWithStartTime:(NSTimeInterval)startTime;

/**
 *  @brief  心率编码
 */
- (NSString *)hm_stringByEncodingHeartRateWithStartTime:(NSTimeInterval)startTime;

/**
 *  @brief  公里编码
 */
- (NSString *)hm_stringByEncodingKiloPace;

/**
 *  @brief  英里编码
 */
- (NSString *)hm_stringByEncodingMilePace;

/**
 *  @brief  气压计编码
 */
- (NSString *)hm_stringByEncodingBarometerPressureWithStartTime:(NSTimeInterval)startTime;

/**
 *  @brief  速度编码
 */
- (NSString *)hm_stringByEncodingSpeedWithStartTime:(NSTimeInterval)startTime;


@end
