//
//  HMDatabaseLogger.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogger.h"
#import "HMLogTypes.h"


@interface HMDatabaseLogger : HMLogger


/**
 查询所有日志数据

 @return 仅DEBUG环境生效
 */
- (NSArray<HMLogItem *> *)queryLogItems;


/**
 按级别查询日志数据

 @param levelSet log级别
 @return 仅DEBUG环境生效
 */
- (NSArray<HMLogItem *> *)queryLogItemsWithLevelSet:(NSSet<NSNumber *> *)levelSet;

@end
