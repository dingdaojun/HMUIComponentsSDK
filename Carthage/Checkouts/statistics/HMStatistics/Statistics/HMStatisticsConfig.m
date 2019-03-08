//  HMStatisticsConfig.m
//  Created on 12/01/2018
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsConfig.h"

@implementation HMStatisticsConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _appID = @"";
        _secret = @"";
        _huamiID = @"";
        _channelID = @"App Store";
        _reportPolicy = HMStatisticsReportPolicyFinishLaunching;
        _minSendInterval = 90;
        _isDebug = YES;
    }

    return self;
}

- (void)setReportPolicy:(HMStatisticsReportPolicy)reportPolicy {

    // 非调试模式下，实时上传策略无效
    if (!_isDebug && reportPolicy == HMStatisticsReportPolicyRealTime) {
        _reportPolicy = HMStatisticsReportPolicyFinishLaunching;
        return;
    }

    _reportPolicy = reportPolicy;
}

- (void)setMinSendInterval:(NSInteger)minSendInterval {

    minSendInterval = MAX(minSendInterval, 90);
    minSendInterval = MIN(minSendInterval, 86400);

    _minSendInterval = minSendInterval;
}

@end
