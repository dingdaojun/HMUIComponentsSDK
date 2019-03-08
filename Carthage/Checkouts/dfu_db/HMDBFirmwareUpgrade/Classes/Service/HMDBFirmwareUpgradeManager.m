//  HMDBFirmwareUpgradeManager.m
//  Created on 14/12/2017
//  Description 文件描述

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBFirmwareUpgradeManager.h"
#import "HMDBFirmwareUpgradeInfoRecord+Protocol.h"
#import "HMDBFirmwareUpgradeInfoTable.h"
#import "HMDBFirmwareUpgradeBaseConfig.h"

@interface HMDBFirmwareUpgradeManager()

@property(nonatomic,strong) HMDBFirmwareUpgradeInfoTable *infoTable;

@end


@implementation HMDBFirmwareUpgradeManager

#pragma mark - 查询操作

/**
 查询所有数据库记录信息
 
 @return 所有数据库记录信息
 */
- (NSArray<id <HMDBFirmwareUpgradeInfoProtocol> > *)allInfos {
    NSError *error = nil;
    
    NSArray *allInfos = [self.infoTable findAllWithError:&error];
    
    if (error) {
        return @[];
    }
    
    return allInfos;
}

/**
 查询某台硬件所有对应所有固件信息
 
 @param deviceSource 硬件设备类型
 @param productVersion 硬件设备版本
 @return 某台硬件所有对应所有固件信息
 */
- (NSArray<id <HMDBFirmwareUpgradeInfoProtocol> > *)fetchInfoWithDeviceSource:(NSInteger)deviceSource
                                                               productVersion:(NSInteger)productVersion {
    NSError *error = nil;
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE deviceSource=%ld AND productVersion=%ld ", self.infoTable.tableName, deviceSource, productVersion];
    
    NSArray *records = [self.infoTable findAllWithSQL:sqlString params:nil error:&error];
    
    if (error) {
        return @[];
    }
    
    return records;
}

/**
 查询特定设备特定文件类型信息

 @param deviceSource 设备类型
 @param fileType 文件类型
 @return 查询结果
 */
- (id <HMDBFirmwareUpgradeInfoProtocol> _Nullable)fetchInfoWithDeviceSource:(NSInteger)deviceSource fwFileType:(NSInteger)fileType {
    NSError *error = nil;

    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE deviceSource=%ld  AND firmwareFileType=%ld", self.infoTable.tableName, deviceSource,fileType];

    HMDBFirmwareUpgradeInfoRecord *record = (HMDBFirmwareUpgradeInfoRecord*)[self.infoTable  findFirstRowWithSQL:sqlString params:nil error:&error];

    if (error ||!record) {
        return nil;
    }

    return record;
}

#pragma mark - 更新操作

/**
 新增或更新一条固件信息
 
 @param info 待操作数据
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)addOrUpdateFirmwareUpgradeInfo:(id<HMDBFirmwareUpgradeInfoProtocol>)info {
    NSError *error = nil;
    
    HMDBFirmwareUpgradeInfoRecord *recordTransform = [[HMDBFirmwareUpgradeInfoRecord alloc] initWithProtocol:info];
    
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE firmwareFileType=%ld AND deviceSource=%ld", self.infoTable.tableName, info.dbFirmwareFileType,info.dbDeviceSource];
    
    HMDBFirmwareUpgradeInfoRecord *existRecord = (HMDBFirmwareUpgradeInfoRecord*)[self.infoTable  findFirstRowWithSQL:sqlString params:nil error:&error];
    
    if (error) {
        return error;
    }
    
    if (existRecord) {
        recordTransform.identifier = existRecord.identifier;
        [self.infoTable updateRecord:recordTransform error:&error];
    } else {
        recordTransform.identifier = nil;
        [self.infoTable insertRecord:recordTransform error:&error];
    }
    
    return error;
}


#pragma mark - 删除操作

/**
 删除数据库中所有固件信息
 */
- (void)removeAllInfos {
    [self.infoTable truncate];
}


/**
 删除某台硬件所有对应所有固件信息
 
 @param deviceSource 硬件设备类型
 @param productVersion 硬件设备版本
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)removeInfoWithDeviceSource:(NSInteger)deviceSource
                                   productVersion:(NSInteger)productVersion {
    NSError *error = nil;

    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE deviceSource=%ld AND productVersion=%ld ", self.infoTable.tableName, deviceSource, productVersion];
    
    BOOL isSuccess = [self.infoTable executeSQL:sqlString error:&error];
    
    if (isSuccess) {
        return nil;
    }
    
    return error;
}

/**
 删除特定设备特定文件类型信息

 @param deviceSource 设备类型
 @param fileType 文件类型
 @return 操作所附带的错误信息，若返回 nil 则表示操作成功，否则表示为空
 */
- (NSError * _Nullable)removeInfoWithDeviceSource:(NSInteger)deviceSource
                                       fwFileType:(NSInteger)fileType {
    NSError *error = nil;

    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE deviceSource=%ld AND firmwareFileType=%ld", self.infoTable.tableName, deviceSource, fileType];

    BOOL isSuccess = [self.infoTable executeSQL:sqlString error:&error];

    if (isSuccess) {
        return nil;
    }

    return error;
}
#pragma mark - 懒加载
- (HMDBFirmwareUpgradeInfoTable *)infoTable {
    if (_infoTable == nil) {
        _infoTable = [[HMDBFirmwareUpgradeInfoTable alloc] init];
    }
    
    return _infoTable;
}

@end
