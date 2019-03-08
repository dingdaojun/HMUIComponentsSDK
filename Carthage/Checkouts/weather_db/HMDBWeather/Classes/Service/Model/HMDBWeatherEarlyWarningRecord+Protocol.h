//  HMDBWeatherEarlyWarningRecord+Protocol.h
//  Created on 19/12/2017
//  Description HMDBWeatherEarlyWarningRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherEarlyWarningRecord.h"
#import "HMDBWeatherEarlyWarningProtocol.h"

@interface HMDBWeatherEarlyWarningRecord (Protocol)<HMDBWeatherEarlyWarningProtocol>

- (instancetype)initWithProtocol:(id<HMDBWeatherEarlyWarningProtocol>)earlyWarning;

@end
