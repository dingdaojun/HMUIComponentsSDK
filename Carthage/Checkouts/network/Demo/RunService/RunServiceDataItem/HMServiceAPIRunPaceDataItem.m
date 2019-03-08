//
//  HMServiceAPIRunPaceDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunPaceDataItem.h"

@implementation HMServiceAPIRunPaceDataItem

- (NSUInteger)api_runPaceKilometer {
    return self.kilometer;
}

- (NSTimeInterval)api_runPaceTime {
    return self.time;
}

- (NSTimeInterval)api_runPaceTotalTime {
    return self.totalTime;
}

- (NSUInteger)api_runPaceHeartRate {
    return self.heartRate;
}

- (CLLocationCoordinate2D)api_runPaceLocation {
    return self.coordinate;
}

@end
