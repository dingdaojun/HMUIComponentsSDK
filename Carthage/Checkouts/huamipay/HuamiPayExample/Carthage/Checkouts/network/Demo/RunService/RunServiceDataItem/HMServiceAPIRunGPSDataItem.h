//
//  HMServiceAPIRunGPSDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMServiceApiRunProtocol.h"

@interface HMServiceAPIRunGPSDataItem : NSObject  <HMServiceAPIRunGPSData>

@property (nonatomic, strong) CLLocation          *loction;
@property (nonatomic, assign) NSTimeInterval      runTime;
@property (nonatomic, assign) double              GPSPace;
@property (nonatomic, assign) NSInteger           GPSFlag;

@end
