//  HMStatisticsNamedContextRecord.m
//  Created on 2018/6/25
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticsNamedContextRecord.h"

@implementation HMStatisticsNamedContextRecord

-(instancetype)init {
    self = [super init];
    if (self) {
        _bundleIdentifier = @"";
        _deviceName = @"";
        _hmID = @"";
        _sysVersion = @"";
        _appVersion = @"";
        _localeIdentifier = @"";
        _eventVersion = @"";
        _sdkVersion = @"";
        _networkStatus = @"";
        _screenInfo = @"";
        _appChannel = @"";
        _platform = @"";
    }
    
    return self;
}

@end
