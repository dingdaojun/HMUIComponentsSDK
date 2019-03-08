//  HMDBWeatherAQIRecord+Protocol.h
//  Created on 19/12/2017
//  Description HMDBWeatherAQIRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherAQIRecord.h"
#import "HMDBWeatherAQIProtocol.h"

@interface HMDBWeatherAQIRecord (Protocol) <HMDBWeatherAQIProtocol>

- (instancetype)initWithProtocol:(id<HMDBWeatherAQIProtocol>)weatherAQI;

@end
