//
//  HMServiceAPIRunPauseDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunPauseDataItem.h"

@implementation HMServiceAPIRunPauseDataItem

- (NSDate *)api_runPauseDate {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (NSUInteger)api_runPauseType {
    return self.type;
}

- (NSTimeInterval)api_runPauseDuration {
    return self.duration;
}

- (NSUInteger)api_runPauseStartGpsIndex {
    return self.startGpsIndex;
}

- (NSUInteger)api_runPauseEndGpsIndex {
    return self.endGpsIndex;
}

@end
