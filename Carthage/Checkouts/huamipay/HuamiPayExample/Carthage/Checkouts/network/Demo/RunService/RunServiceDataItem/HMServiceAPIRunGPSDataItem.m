//
//  HMServiceAPIRunGPSDataItem.m
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunGPSDataItem.h"

@implementation HMServiceAPIRunGPSDataItem

- (CLLocation *)api_runGPSDataLoction {
    return self.loction;
}

- (NSTimeInterval)api_runGPSRunTime {
    return self.runTime;
}

- (double)api_runGPSPace {
    return self.GPSPace;
}

- (NSInteger)api_runGPSFlag {
    return self.GPSFlag;
}

- (CLLocationDistance)api_runGPSAltitude {
    return self.loction.altitude;
}


@end
