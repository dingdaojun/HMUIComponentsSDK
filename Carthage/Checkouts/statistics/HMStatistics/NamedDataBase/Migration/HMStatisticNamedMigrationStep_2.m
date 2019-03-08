//  HMStatisticNamedMigrationStep_2.m
//  Created on 2018/6/25
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMStatisticNamedMigrationStep_2.h"

@implementation HMStatisticNamedMigrationStep_2

- (void)goUpWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    // 添加相关 Column
    [[queryCommand addColumn:@"contextID" columnInfo:@"INTEGER" tableName:@"named_event" error:error] executeWithError:error];
    
    // 清空垃圾数据
    [[queryCommand compileSqlString:@"DELETE FROM named_event" bindValueList:nil error:NULL] executeWithError:NULL];
}

- (void)goDownWithQueryCommand:(CTPersistanceQueryCommand *)queryCommand error:(NSError *__autoreleasing *)error {
    
}

@end
