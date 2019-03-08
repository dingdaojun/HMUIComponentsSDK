//  HMDBAdServices+General.m
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBAdServices+General.h"
#import "HMDBAdGeneralVirtualRecord.h"
#import "HMDBAdGeneralTable.h"
#import "HMDBAdGeneralResourceTable.h"
#import "HMDBAdGeneralRecord.h"
#import "HMDBAdGeneralResourceRecord+Protocol.h"

@implementation HMDBAdServices (General)

/**
 查询所有通用广告记录
 
 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdGeneralProtocol> > *)allGeneralAds {
    NSMutableArray *allResults = [NSMutableArray array];
    
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    NSArray *allGeneral = [generalTable findAllWithError:&error];
    
    if (error) {
        return @[];
    }
    
    for (HMDBAdGeneralRecord *generalRecord in allGeneral) {
        id <HMDBAdGeneralProtocol> protocol = [self generalAdWithAdvertisementID:generalRecord.adID moduleType:generalRecord.adModuleType];
        
        if (protocol) {
            [allResults addObject:protocol];
        }
    }
    
    return allResults;
}

/**
 查询特定模块通用广告记录
 @param moduleType 所属模块
 
 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdGeneralProtocol> > *)allModuleAds:(HMDBAdModuleType)moduleType {
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    NSArray *generalArr = [generalTable findAllWithKeyName:@"adModuleType" value:@(moduleType) error:&error];
    
    if (error) {
        return @[];
    }
    
    NSMutableArray *results = [NSMutableArray array];
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    for (HMDBAdGeneralRecord *generalRecord in generalArr) {
        NSArray *resourceArr = [resourceTable findAllWithKeyName:@"generalID" value:generalRecord.identifier error:&error];
        
        HMDBAdGeneralVirtualRecord *virtual = [[HMDBAdGeneralVirtualRecord alloc] initWithRecord:generalRecord andResource:resourceArr];
        [results addObject:virtual];
    }
    
    return results;
}

/**
 查询特定通用广告记录
 
 @param advertisementID 广告记录标示 ID
 @param moduleType 所属模块
 @return 通用广告记录
 */
-(id <HMDBAdGeneralProtocol> _Nullable)generalAdWithAdvertisementID:(NSString *)advertisementID moduleType:(HMDBAdModuleType)moduleType {
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE adID = '%@' AND adModuleType = %lu", generalTable.tableName, advertisementID, (unsigned long)moduleType];
    
    NSArray *generalArr =  [generalTable findAllWithSQL:sql params:nil error:&error];
    
    if (error || generalArr.count < 1) {
        return nil;
    }
    
    HMDBAdGeneralRecord *generalRecord = [generalArr firstObject];
    
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    NSArray *resourceArr = [resourceTable findAllWithKeyName:@"generalID" value:generalRecord.identifier error:&error];
    
    if (error) {
        return nil;
    }
    
    HMDBAdGeneralVirtualRecord *virtual = [[HMDBAdGeneralVirtualRecord alloc] initWithRecord:generalRecord andResource:resourceArr];
    
    return virtual;
}

/**
 新增通用广告记录
 
 @param protocol 待新增记录
 @return 是否新增成功
 */
-(BOOL)addGeneralAd:(id <HMDBAdGeneralProtocol>)protocol {
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    HMDBAdGeneralVirtualRecord *virtualRecord = [[HMDBAdGeneralVirtualRecord alloc] initWithProtocol:protocol];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE adID = '%@' AND adModuleType = %lu", generalTable.tableName, virtualRecord.db_adID, (unsigned long)virtualRecord.db_adModuleType];
    
    NSArray *generalArr =  [generalTable findAllWithSQL:sql params:nil error:&error];
    
    // if error or have the same record , return NO
    if (error || generalArr.count > 0) {
        return NO;
    }
    
    
    [generalTable insertRecord:virtualRecord.generalAd error:&error];
    
    if (error) {
        return NO;
    }
    
    NSMutableArray *insertResource = [virtualRecord.virtualAdResource mutableCopy];
    
    for (HMDBAdGeneralResourceRecord *resource  in insertResource) {
        resource.generalID = virtualRecord.generalAd.identifier;
    }
    
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    BOOL isSucess = [resourceTable insertRecordList:insertResource error:&error];
    
    if (error) {
        return NO;
    }
    
    return isSucess;
}

/**
 删除特定模块通用广告记录
 
 @param moduleType 所属模块
 @return 是否删除成功
 */
-(BOOL)deleteModuleAds:(HMDBAdModuleType)moduleType {
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    NSArray *generalArr = [generalTable findAllWithKeyName:@"adModuleType" value:@(moduleType) error:&error];
    
    if (error) {
        return NO;
    }
    
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    for (HMDBAdGeneralRecord *generalRecord in generalArr) {
        [resourceTable deleteRecordWhereKey:@"generalID" value:generalRecord.identifier error:&error];
        
        if (error) {
            return NO;
        }
        
        [generalTable deleteRecord:generalRecord error:&error];
        
        if (error) {
            return NO;
        }
    }
    
    return YES;
}

/**
 删除特定通用广告记录
 
 @param advertisementID 广告标示
 @param moduleType 所属模块
 @return 是否删除成功
 */
-(BOOL)deleteGeneralAdWithAdvertisementID:(NSString *)advertisementID moduleType:(HMDBAdModuleType)moduleType {
    NSError *error = nil;
    
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE adID = '%@' AND adModuleType = %lu", generalTable.tableName, advertisementID, (unsigned long)moduleType];
    
    NSArray *generalArr =  [generalTable findAllWithSQL:sql params:nil error:&error];
    
    if (error) {
        return NO;
    }
    
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    for (HMDBAdGeneralRecord *generalRecord in generalArr) {
        [resourceTable deleteRecordWhereKey:@"generalID" value:generalRecord.identifier error:&error];
        
        if (error) {
            return NO;
        }
        
        [generalTable deleteRecord:generalRecord error:&error];
        
        if (error) {
            return NO;
        }
    }
    
    return YES;
}

/**
 删除所有通用广告记录
 */
-(void)removeAllGeneralAds {
    HMDBAdGeneralTable *generalTable = [[HMDBAdGeneralTable alloc] init];
    
    [generalTable truncate];
    
    HMDBAdGeneralResourceTable *resourceTable = [[HMDBAdGeneralResourceTable alloc] init];
    
    [resourceTable truncate];
}

@end
