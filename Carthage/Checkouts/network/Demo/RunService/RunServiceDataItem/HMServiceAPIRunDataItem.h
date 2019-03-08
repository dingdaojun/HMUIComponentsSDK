//
//  HMServiceAPIRunDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMServiceApiRunProtocol.h"


@interface HMServiceAPIRunDataItem : NSObject

@property (nonatomic, assign) NSTimeInterval    time;
@property (nonatomic, strong) NSNumber          *value;

@end

@interface HMServiceAPIRunDataItem (HMServiceAPIRunCorrectAltitudeData)  <HMServiceAPIRunCorrectAltitudeData>
@end


@interface HMServiceAPIRunDataItem (HMServiceAPIRunStrokeSpeedData) <HMServiceAPIRunStrokeSpeedData>
@end


@interface HMServiceAPIRunDataItem (HMServiceAPIRunCadenceData) <HMServiceAPIRunCadenceData>
@end



@interface HMServiceAPIRunDataItem (HMServiceAPIRunHeartRateData) <HMServiceAPIRunHeartRateData>
@end


@interface HMServiceAPIRunDataItem (HMServiceAPIRunDistanceData) <HMServiceAPIRunDistanceData>
@end

@interface HMServiceAPIRunDataItem (HMServiceAPIRunPressureData) <HMServiceAPIRunPressureData>
@end

@interface HMServiceAPIRunDataItem (HMServiceAPIRunSpeedData) <HMServiceAPIRunSpeedData>
@end

