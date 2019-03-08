//  HMDBCurrentWeatherRecord+Protocol.h
//  Created on 18/12/2017
//  Description HMDBCurrentWeatherRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBCurrentWeatherRecord.h"
#import "HMDBCurrentWeatherProtocol.h"

@interface HMDBCurrentWeatherRecord (Protocol) <HMDBCurrentWeatherProtocol>

- (instancetype)initWithProtocol:(id<HMDBCurrentWeatherProtocol>)currentWeather;

@end
