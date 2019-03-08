//  HMDBWeatherForecastRecord+Protocol.h
//  Created on 19/12/2017
//  Description HMDBWeatherForecastRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherForecastRecord.h"
#import "HMDBWeatherForecastProtocol.h"

@interface HMDBWeatherForecastRecord (Protocol) <HMDBWeatherForecastProtocol>

- (instancetype)initWithProtocol:(id<HMDBWeatherForecastProtocol>)weatherForecast;

@end
