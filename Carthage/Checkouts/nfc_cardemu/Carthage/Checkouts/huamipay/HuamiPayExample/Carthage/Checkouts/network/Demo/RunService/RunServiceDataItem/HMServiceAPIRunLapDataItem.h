//
//  HMServiceAPIRunLapDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunDataItem.h"

@interface HMServiceAPIRunLapDataItem : HMServiceAPIRunDataItem <HMServiceAPIRunLapData>

@property (nonatomic, assign) int                      lapIndex;
@property (nonatomic, assign) CLLocationDistance       distance;
@property (nonatomic, assign) CLLocationCoordinate2D   location;
@property (nonatomic, assign) int                      averageHeartRate;
@property (nonatomic, assign) NSTimeInterval           runTime;
@property (nonatomic, assign) CLLocationDistance       altitude;
@property (nonatomic, assign) CLLocationDistance       altitudeAscend;
@property (nonatomic, assign) CLLocationDistance       altitudeDescend;
@property (nonatomic, assign) double                   averagePace;
@property (nonatomic, assign) double                   maxPace;
@property (nonatomic, assign) CLLocationDistance       ascendDistance;
@property (nonatomic, assign) NSInteger                averageStrokeSpeed;
@property (nonatomic, assign) NSInteger                atrokeEfficiency;
@property (nonatomic, assign) NSInteger                strokeTime;
@property (nonatomic, assign) NSInteger                calorie;
@property (nonatomic, assign) NSInteger                averageFrequency;
@property (nonatomic, assign) NSInteger                averageCadence;
@property (nonatomic, assign) HMServiceAPIRunLapType   type;

@end
