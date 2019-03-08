//  HMDBFirmwareUpgradeInfoRecord+Protocol.h
//  Created on 2018/6/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBFirmwareUpgradeInfoRecord.h"
#import "HMDBFirmwareUpgradeInfoProtocol.h"

@interface HMDBFirmwareUpgradeInfoRecord (Protocol)<HMDBFirmwareUpgradeInfoProtocol>

- (instancetype)initWithProtocol:(id<HMDBFirmwareUpgradeInfoProtocol>)protocol;

@end
