//  HMDBAdServices+General.h
//  Created on 2018/7/8
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author wumingliang(wumingliang@huami.com)

#import "HMDBAdServices.h"
#import "HMDBAdGeneralProtocol.h"

@interface HMDBAdServices (General)

/**
 查询所有通用广告记录
 
 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdGeneralProtocol> > *)allGeneralAds;

/**
 查询特定模块通用广告记录
 @param moduleType 所属模块
 
 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdGeneralProtocol> > *)allModuleAds:(HMDBAdModuleType)moduleType;

/**
 查询特定通用广告记录
 
 @param advertisementID 广告记录标示 ID
 @param moduleType 所属模块
 @return 通用广告记录
 */
-(id <HMDBAdGeneralProtocol> _Nullable)generalAdWithAdvertisementID:(NSString *)advertisementID moduleType:(HMDBAdModuleType)moduleType;

/**
 新增通用广告记录
 
 @param protocol 待新增记录
 @return 是否新增成功
 */
-(BOOL)addGeneralAd:(id <HMDBAdGeneralProtocol>)protocol;

/**
 删除特定模块通用广告记录
 
 @param moduleType 所属模块
 @return 是否删除成功
 */
-(BOOL)deleteModuleAds:(HMDBAdModuleType)moduleType;

/**
 删除特定通用广告记录
 
 @param advertisementID 广告标示
 @param moduleType 所属模块
 @return 是否删除成功
 */
-(BOOL)deleteGeneralAdWithAdvertisementID:(NSString *)advertisementID moduleType:(HMDBAdModuleType)moduleType;

/**
 删除所有通用广告记录
 */
-(void)removeAllGeneralAds;

@end
