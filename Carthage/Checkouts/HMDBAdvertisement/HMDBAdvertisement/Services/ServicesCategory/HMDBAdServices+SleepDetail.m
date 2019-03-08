//  HMDBAdServices+SleepDetail.m
//  Created on 2018/5/31
//  Description 睡眠详情广告模块

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBAdServices+SleepDetail.h"
#import "HMAdSleepDetailRecord+Protocol.h"
#import "HMAdSleepDetailTable.h"

@implementation HMDBAdServices (SleepDetail)

/**
 查询所有睡眠详情广告记录

 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdSleepDetailProtocol> > *)allSleepDetailAds {
    NSError *error = nil;

    HMAdSleepDetailTable *table = [[HMAdSleepDetailTable alloc] init];

    NSArray *results = [table findAllWithError:&error];

    if (error) {
        return @[];
    }

    return results;
}

/**
 查询特定睡眠详情广告记录

 @param advertisementID 广告记录标示 ID
 @return 睡眠详情广告记录
 */
-(id <HMDBAdSleepDetailProtocol> _Nullable)querySleepDetailWithAdvertisementID:(NSString *)advertisementID {
    NSError *error = nil;

    HMAdSleepDetailTable *table = [[HMAdSleepDetailTable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE advertisementID = '%@' ", table.tableName, advertisementID];

    HMAdSleepDetailRecord *record = (HMAdSleepDetailRecord *)[table findFirstRowWithSQL:sql params:nil error:&error];

    if (error) {
        return nil;
    }

    return record;
}

/**
 批量插入睡眠详情广告记录

 @param protocols 待新增记录
 @return 是否新增成功
 */
-(BOOL)addSleepDetailAds:(NSArray< id <HMDBAdSleepDetailProtocol> > *)protocols {

    NSError *error = nil;

    NSMutableArray *records = [NSMutableArray arrayWithCapacity:3];

    HMAdSleepDetailTable *table = [[HMAdSleepDetailTable alloc] init];

    for (id <HMDBAdSleepDetailProtocol> protocol in protocols) {
        HMAdSleepDetailRecord *record = [[HMAdSleepDetailRecord alloc] initWithProtocol:protocol];
        [records addObject:record];
    }

    BOOL isSuccess = [table insertRecordList:records error:&error];

    return isSuccess;
}

/**
 删除特定睡眠详情广告记录

 @param advertisementID 广告标示
 @return 是否删除成功
 */
-(BOOL)deleteSleepDetailWithAdvertisementID:(NSString *)advertisementID {

    NSError *error = nil;

    HMAdSleepDetailTable *table = [[HMAdSleepDetailTable alloc] init];

    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE advertisementID = '%@' ", table.tableName, advertisementID];

    BOOL isSuccess = [table executeSQL:sql error:&error];

    if (error) {
        return NO;
    }

    return isSuccess;
}

/**
 删除所有睡眠详情广告记录
 */
-(void)removeAllSleepDetailAds {
    HMAdSleepDetailTable *table = [[HMAdSleepDetailTable alloc] init];

    [table truncate];
}

@end
