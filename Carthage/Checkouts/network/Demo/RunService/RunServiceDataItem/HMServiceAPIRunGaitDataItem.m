//
//  HMServiceAPIRunGaitDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunGaitDataItem.h"

@implementation HMServiceAPIRunGaitDataItem

- (NSDate *)api_runGaitDate {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (NSInteger)api_runGaitStep {
    return self.step;
}

- (NSInteger)api_runGaitStepLength {
    return self.stepLength;
}

- (NSInteger)api_runGaitStepCadence {
    return self.stepCadence;
}

@end
