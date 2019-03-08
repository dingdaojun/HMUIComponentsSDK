//  HMDBAdServices+SleepDetail.h
//  Created on 2018/5/31
//  Description 睡眠详情广告模块

//  Copyright © 2018 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMDBAdServices.h"
#import "HMDBAdSleepDetailProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMDBAdServices (SleepDetail)

/**
 查询所有睡眠详情广告记录

 @return 所有睡眠详情广告记录
 */
-(NSArray< id <HMDBAdSleepDetailProtocol> > *)allSleepDetailAds;

/**
 查询特定睡眠详情广告记录

 @param advertisementID 广告记录标示 ID
 @return 睡眠详情广告记录
 */
-(id <HMDBAdSleepDetailProtocol> _Nullable)querySleepDetailWithAdvertisementID:(NSString *)advertisementID;

/**
 批量插入睡眠详情广告记录

 @param protocols 待新增记录
 @return 是否新增成功
 */
-(BOOL)addSleepDetailAds:(NSArray< id <HMDBAdSleepDetailProtocol> > *)protocols;

/**
 删除特定睡眠详情广告记录

 @param advertisementID 广告标示
 @return 是否删除成功
 */
-(BOOL)deleteSleepDetailWithAdvertisementID:(NSString *)advertisementID;

/**
 删除所有睡眠详情广告记录
 */
-(void)removeAllSleepDetailAds;

@end

NS_ASSUME_NONNULL_END
