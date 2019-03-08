//  HMAdSleepDetailRecord+Protocol.h
//  Created on 2018/5/31
//  Description <#文件描述#>

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMAdSleepDetailRecord.h"
#import "HMDBAdSleepDetailProtocol.h"

@interface HMAdSleepDetailRecord (Protocol) <HMDBAdSleepDetailProtocol>

- (instancetype)initWithProtocol:(id <HMDBAdSleepDetailProtocol> )protocol;

@end
