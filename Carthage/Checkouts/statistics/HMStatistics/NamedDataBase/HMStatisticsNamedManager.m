//  HMStatisticsNamedManager.m
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsNamedManager.h"
#import "HMStatisticsNamedTable.h"
#import "HMStatisticsNamedRecord.h"
#import "HMStatisticsNamedContextTable.h"
#import "HMStatisticsNamedContextRecord.h"
#import <CTPersistance/CTPersistance.h>
#import <CTPersistance/CTPersistanceAsyncExecutor.h>

@implementation HMStatisticsNamedManager

#pragma mark - 匿名数据表

/**
 按照上下文获取分组事件数据
 
 @param competionHandler 事件回调
 */
- (void)asyncFetchAllNamedEventWithGroup:(void (^)(NSArray< NSArray<HMStatisticsNamedRecord *> *> *groupReslut,  NSArray<HMStatisticsNamedContextRecord *> *groupContext))competionHandler {
    [[CTPersistanceAsyncExecutor sharedInstance] read:^{
        NSError *error = nil;
        
        HMStatisticsNamedContextTable *contextTable = [[HMStatisticsNamedContextTable alloc] init];
        NSArray *allContext = [contextTable findAllWithError:&error];
        
        if (error) {
            allContext = @[];
        }
        
        // 分组
        NSMutableArray *groupReslut = [NSMutableArray array];
        NSMutableArray *groupContext = [NSMutableArray array];
        
        HMStatisticsNamedTable *eventTable = [[HMStatisticsNamedTable alloc] init];
        for (HMStatisticsNamedContextRecord *context in allContext) {
            NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE contextID = %@ ORDER BY  eventTimestamp",eventTable.tableName,context.identifier];
            
            NSArray *results = [eventTable findAllWithSQL:sqlString params:nil error:&error];
            
            if (error) {
                groupReslut = [NSMutableArray array];
                groupContext = [NSMutableArray array];
                break;
            }
            
            if (results.count < 1) {
                continue;
            }
            
            [groupReslut addObject:results];
            [groupContext addObject:context];
        }
        
        if (competionHandler) {
            competionHandler(groupReslut,groupContext);
        }
        
    }];
}

/**
 新增具名记录
 
 @param record 待新增记录
 @param competionHandler 操作结果回调
 */
- (void)asyncAddNamedEvent:(HMStatisticsNamedRecord *)record withCompetion:(nullable NamedAsyncWriteBlock)competionHandler {
    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSError *error = nil;
        record.identifier = nil;
        
        HMStatisticsNamedTable *table = [[HMStatisticsNamedTable alloc] init];
        BOOL isSuccess = [table insertRecord:record error:&error];
        
        NSAssert(error == nil, @"HMStatisticsNamedTable addNamedEventRecord ");
        
        if (error) {
            isSuccess = NO;
        }
        
        if (competionHandler) {
            competionHandler(isSuccess);
        }
    }];
}

/**
 批量删除具名记录
 
 @param events 待删除记录
 @param competionHandler 删除回调
 */
- (void)asyncDeleteNamedEvents:(NSArray<HMStatisticsNamedRecord *> *)events withCompetion:(nullable NamedAsyncWriteBlock)competionHandler {
    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSError *error = nil;
        
        HMStatisticsNamedTable *table = [[HMStatisticsNamedTable alloc] init];
        [table deleteRecordList:events error:&error];
        
        NSAssert(error == nil, @"HMStatisticsNamedTable deleteNamedEventRecords ");
        
        BOOL isSuccess = YES;
        
        if (error) {
            isSuccess = NO;
        }
        
        if (competionHandler) {
            competionHandler(isSuccess);
        }
    }];
}

#pragma mark - 匿名上下文表

/**
 检查当前上下文是否存在，若不存在则新增上下文
 
 @param context 带检查上下文
 @param competionHandler 回调处理 isSuccess 是否添加成功 contexID 对应主键
 */
-(void)asyncAddContext:(HMStatisticsNamedContextRecord *)context withCompetion:(void(^)(BOOL isSuccess,NSNumber * _Nullable contextID))competionHandler{
    
    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        NSError *error = nil;
        // 检查是否存在相同 context
        HMStatisticsNamedContextTable *table = [[HMStatisticsNamedContextTable alloc] init];
        
        NSString *sqlWhere = [NSString stringWithFormat:@"hmID = '%@' AND sysVersion = '%@' AND appVersion = '%@' AND localeIdentifier = '%@' AND eventVersion = '%@' AND sdkVersion = '%@' AND networkStatus = '%@' AND appChannel = '%@' AND platform = '%@'",context.hmID,context.sysVersion,context.appVersion,context.localeIdentifier,context.eventVersion,context.sdkVersion,context.networkStatus,context.appChannel,context.platform];
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",table.tableName,sqlWhere];
        
        NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];
        
        if (error && competionHandler) {
            competionHandler(NO,nil);
            return;
        }
        
        if (results.count > 0 && competionHandler) {
            HMStatisticsNamedContextRecord *firstRecord = [results firstObject];
            competionHandler(YES,firstRecord.identifier);
            return;
        }
        
        if (error || results.count > 0) {
            return;
        }
        
        // 新增 context
        
        BOOL isSuccess = [table insertRecord:context error:&error];
        
        if (error) {
            isSuccess = NO;
            context.identifier = nil;
        }
        
        if (competionHandler) {
            competionHandler(isSuccess,context.identifier);
        }
        
        return;
    }];
}

/**
 刷新上下文表
 
 @param context 上下文 ID
 @param competionHandler 刷新回调
 */
-(void)asyncRefreshContext:(HMStatisticsNamedContextRecord *)context withCompetion:(nullable NamedAsyncWriteBlock)competionHandler {
    
    // 是否为当前版本上下文
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    if (!appVersion) {
        appVersion = @"";
    }
    
    if ([appVersion isEqualToString:context.appVersion]) {
        return;
    }
    
    [[CTPersistanceAsyncExecutor sharedInstance] write:^{
        
        // 检查事件表是否存在 contexID 相关事件
        NSError *error = nil;
        
        HMStatisticsNamedTable *table = [[HMStatisticsNamedTable alloc] init];
        
        NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE contextID = %@ ",table.tableName,context.identifier];
        
        NSArray *results = [table findAllWithSQL:sqlString params:nil error:&error];
        
        NSAssert(error == nil, @"HMStatisticsAnonymousTable asyncRefreshContex");
        
        if (error && competionHandler) {
            competionHandler(NO);
            return;
        }
        
        if (results.count > 0 && competionHandler) {
            competionHandler(YES);
            return;
        }
        
        if (error || results.count > 0) {
            return;
        }
        
        // 删除相关 context
        HMStatisticsNamedContextTable *contextTable = [[HMStatisticsNamedContextTable alloc] init];
        
        [contextTable deleteWithPrimaryKey:context.identifier error:&error];
        
        BOOL isSuccess = YES;
        
        if (error) {
            isSuccess = NO;
        }
        
        if (competionHandler) {
            competionHandler(YES);
        }
    }];
}

@end
