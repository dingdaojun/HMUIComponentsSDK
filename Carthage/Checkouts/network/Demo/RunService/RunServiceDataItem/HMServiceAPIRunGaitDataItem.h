//
//  HMServiceAPIRunGaitDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunDataItem.h"

@interface HMServiceAPIRunGaitDataItem : HMServiceAPIRunDataItem <HMServiceAPIRunGaitData>

@property (nonatomic, assign) NSInteger         step;
@property (nonatomic, assign) NSInteger         stepLength;
@property (nonatomic, assign) NSInteger         stepCadence;

@end
