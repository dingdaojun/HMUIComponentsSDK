//
//  HMServiceAPIRunPauseDataItem.h
//  HMServiceAPI+Run
//
//  Created by 单军龙 on 2017/10/26.
//  Copyright © 2017年 lixian@huami.com. All rights reserved.
//

#import "HMServiceAPIRunDataItem.h"

@interface HMServiceAPIRunPauseDataItem : HMServiceAPIRunDataItem <HMServiceAPIRunPauseData>

@property (nonatomic, assign) NSInteger         type;
@property (nonatomic, assign) NSInteger         duration;
@property (nonatomic, assign) NSInteger         startGpsIndex;
@property (nonatomic, assign) NSInteger         endGpsIndex;

@end
