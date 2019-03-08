//
//  HMDatabaseLogger.h
//  HMLog
//
//  Created by 李宪 on 22/12/2016.
//  Copyright © 2016 李宪. All rights reserved.
//

#import "HMLogger.h"
#import "HMLogLevel.h"


@interface HMDatabaseLogger : NSObject <HMLogger>

+ (instancetype)sharedLogger;


@property (nonatomic, copy) NSString *path;

// The log levels which can be record in database, if unset all log levels will be output to database. Default is nil.
@property (nonatomic, strong) NSSet<NSNumber *> *filterLevels;

// The log tags which can be record in database, if unset all log tags will be output to database. Default is nil.
@property (nonatomic, strong) NSSet<NSString *> *filterTags;

// The maximum log items can be record in database
@property (nonatomic, assign) NSUInteger maximumItemCount;

@end



@interface HMDatabaseLogger (Query)

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
