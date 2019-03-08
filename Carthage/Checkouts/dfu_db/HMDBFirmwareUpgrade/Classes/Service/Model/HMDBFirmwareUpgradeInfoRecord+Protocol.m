//  HMDBFirmwareUpgradeInfoRecord+Protocol.m
//  Created on 2018/6/27
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBFirmwareUpgradeInfoRecord+Protocol.h"

@implementation HMDBFirmwareUpgradeInfoRecord (Protocol)

- (instancetype)initWithProtocol:(id<HMDBFirmwareUpgradeInfoProtocol>)protocol {
    self = [super init];
    if (self) {
        self.productVersion = protocol.dbProductVersion;
        self.deviceSource = protocol.dbDeviceSource;
        self.firmwareVersion = protocol.dbFirmwareVersion;
        self.firmwareName  = protocol.dbFirmwareName;
        self.firmwareURL = protocol.dbFirmwareURL;
        self.firmwareLocalPath = protocol.dbFirmwareLocalPath;
        self.firmwareMD5 = protocol.dbFirmwareMD5;
        self.isCompressionFile = protocol.dbIsCompressionFile;
        self.firmwareUpgradeType = protocol.dbFirmwareUpgradeType;
        self.latestAbandonUpdateVersion = protocol.dbLatestAbandonUpdateVersion;
        self.isShowDeviceRedPoint = protocol.dbIsShowDeviceRedPoint;
        self.isShowTabRedPoint = protocol.dbIsShowTabRedPoint;
        
        long long milliSeconds = -1;
        if (protocol.dbLatestAbandonUpdateTime) {
            milliSeconds =  [protocol.dbLatestAbandonUpdateTime timeIntervalSince1970] * 1000;
        }
        self.latestAbandonUpdateTimeInterval = milliSeconds;
        
        self.firmwareFileType = protocol.dbFirmwareFileType;
        self.firmwareLanguangeFamily = protocol.dbFirmwareLanguangeFamily;
        self.extensionValue = protocol.dbExtensionValue;
    }
    
    return self;
}

- (NSInteger)dbProductVersion {
    return self.productVersion;
}

- (NSInteger)dbDeviceSource {
    return self.deviceSource;
}

- (NSString *)dbFirmwareVersion {
    return self.firmwareVersion;
}

- (NSString *)dbFirmwareName {
    return self.firmwareName;
}

- (NSString *)dbFirmwareURL {
    return self.firmwareURL;
}

- (NSString *)dbFirmwareLocalPath {
    return self.firmwareLocalPath;
}

- (NSString *)dbFirmwareMD5 {
    return self.firmwareMD5;
}

- (NSInteger)dbFirmwareUpgradeType {
    return self.firmwareUpgradeType;
}

- (NSString *)dbLatestAbandonUpdateVersion {
    return self.latestAbandonUpdateVersion;
}

- (BOOL)dbIsCompressionFile {
    return self.isCompressionFile;
}

- (BOOL)dbIsShowDeviceRedPoint {
    return self.isShowDeviceRedPoint;
}

- (BOOL)dbIsShowTabRedPoint {
    return self.isShowTabRedPoint;
}

- (NSDate *)dbLatestAbandonUpdateTime {
    if (self.latestAbandonUpdateTimeInterval < 0.0) {
        return nil;
    }
    
    double seconds = self.latestAbandonUpdateTimeInterval / 1000.0;
    
    return [[NSDate date] initWithTimeIntervalSince1970:seconds];
}

- (NSInteger)dbFirmwareFileType {
    return self.firmwareFileType;
}

- (NSInteger)dbFirmwareLanguangeFamily {
    return self.firmwareLanguangeFamily;
}

- (NSString *)dbExtensionValue {
    return self.extensionValue;
}

@end
