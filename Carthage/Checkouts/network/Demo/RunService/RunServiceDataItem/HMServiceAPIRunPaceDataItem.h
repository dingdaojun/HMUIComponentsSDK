//
//  HMServiceAPIRunPaceDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunDataItem.h"

@interface HMServiceAPIRunPaceDataItem : NSObject <HMServiceAPIRunPaceData>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSTimeInterval    time;
@property (nonatomic, assign) NSTimeInterval    totalTime;
@property (nonatomic, assign) NSInteger         heartRate;
@property (nonatomic, assign) NSInteger         kilometer;

@property (nonatomic, strong) NSDate         *timestamp;

@end
