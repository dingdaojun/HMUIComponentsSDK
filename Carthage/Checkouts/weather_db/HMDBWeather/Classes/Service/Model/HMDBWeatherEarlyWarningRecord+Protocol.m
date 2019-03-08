//  HMDBWeatherEarlyWarningRecord+Protocol.m
//  Created on 19/12/2017
//  Description HMDBWeatherEarlyWarningRecord 的协议实现

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBWeatherEarlyWarningRecord+Protocol.h"

@implementation HMDBWeatherEarlyWarningRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBWeatherEarlyWarningProtocol>)earlyWarning {
    self = [super init];
    if (self) {
        self.earlyWarningPublishTime = earlyWarning.dbEarlyWarningPublishTime;
        self.warningID = earlyWarning.dbWarningID;
        self.title = earlyWarning.dbTitle;
        self.detail = earlyWarning.dbDetail;
        
        long long milliSeconds = [earlyWarning.dbRecordUpdateTime timeIntervalSince1970] * 1000;
        self.recordUpdateTimeInterval = milliSeconds;
        self.locationKey = earlyWarning.dbLocationKey;
    }
    
    return self;
}

- (NSNumber *)dbIdentifier {
    return self.identifier;
}

- (NSString *)dbEarlyWarningPublishTime {
    return self.earlyWarningPublishTime;
}

- (NSString *)dbWarningID {
    return self.warningID;
}

- (NSString *)dbTitle {
    return self.title;
}

- (NSString *)dbDetail {
    return self.detail;
}

- (NSDate *)dbRecordUpdateTime {
    double seconds = self.recordUpdateTimeInterval / 1000.0;

    return [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
}

- (NSString *)dbLocationKey {
    return self.locationKey;
}

@end
