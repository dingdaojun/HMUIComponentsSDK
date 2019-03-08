//  HMDBFirmwareUpgradeMigrationStep_2.m
//  Created on 4/6/2017
//  Description 数据库 v2 版本迁移操作

//  Copyright © 2017 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com

#import "HMDBFirmwareUpgradeMigrationStep_2.h"

@implementation HMDBFirmwareUpgradeMigrationStep_2

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{
    // 新增 firmwareFileType、firmwareLanguangeFamily字段，
    [[queryCommand addColumn:@"firmwareFileType" columnInfo:@"INTEGER" tableName:@"firmware_info" error:error] executeWithError:error];

    [[queryCommand addColumn:@"firmwareLanguangeFamily" columnInfo:@"INTEGER" tableName:@"firmware_info" error:error] executeWithError:error];
    
    // 注意 firmware_info 表设计前期设计有缺陷，现已废弃改用 firmware_infoV2
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error
{

}

@end
