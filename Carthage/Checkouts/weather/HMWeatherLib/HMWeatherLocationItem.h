//
//  HMWeatherLocationItem.h
//  MiFit
//
//  Created by luoliangliang on 2018/1/19.
//  Copyright © 2018年 Anhui Huami Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WeatherService.HMServiceApiWeatherProtocol;

@interface HMWeatherLocationItem : NSObject

@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString *locationKey;
// 行政区经纬度
@property (assign, nonatomic) float longitude;
@property (assign, nonatomic) float latitude;
// 当前请求经纬度
@property (assign, nonatomic) float currentLongitude;
@property (assign, nonatomic) float currentLatitude;

@property (copy, nonatomic) NSString *affiliation;
@property (copy, nonatomic) NSString *name;

- (id)storeObj;
+ (instancetype)fromStoreObj:(id)data;
- (instancetype)initWithLocation:(id<HMServiceAPIWeatherLocationData>)locationData;
@end
