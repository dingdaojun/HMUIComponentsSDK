//  HMDBFirmwareUpgradeInfoRecord.m
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBFirmwareUpgradeInfoRecord.h"

@implementation HMDBFirmwareUpgradeInfoRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        _productVersion = 0;
        _deviceSource = 0;
        _firmwareVersion = @"";
        _firmwareName = @"";
        _firmwareURL = @"";
        _firmwareLocalPath = @"";
        _firmwareMD5 = @"";
        _firmwareUpgradeType = 0;
        _latestAbandonUpdateVersion = @"";
        _isCompressionFile = NO;
        _isShowDeviceRedPoint = NO;
        _isShowTabRedPoint = NO;
        _latestAbandonUpdateTimeInterval = -1;
        _firmwareFileType = 0;
        _firmwareLanguangeFamily = 0;
        _extensionValue = @"";
    }
    
    return self;
}
@end
