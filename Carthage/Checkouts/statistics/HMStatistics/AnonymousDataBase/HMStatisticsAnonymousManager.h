//  HMStatisticsAnonymousManager.h
//  Created on 2018/4/12
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import <Foundation/Foundation.h>

@class HMStatisticsAnonymousRecord,HMStatisticsAnonymousContextRecord;

typedef void (^AnonymousAsyncReadBlock)(NSArray<HMStatisticsAnonymousRecord *> *resluts);
typedef void (^AnonymousAsyncWriteBlock)(BOOL isSuccess);

NS_ASSUME_NONNULL_BEGIN

@interface HMStatisticsAnonymousManager : NSObject

#pragma mark - 匿名数据表

/**
 按照上下文获取分组事件数据

 @param competionHandler 事件回调
 */
- (void)asyncFetchAllAnonymousEventWithGroup:(void (^)(NSArray< NSArray<HMStatisticsAnonymousRecord *> *> *groupReslut,  NSArray<HMStatisticsAnonymousContextRecord *> *groupContext))competionHandler;
/**
 新增匿名记录

 @param record 待新增记录
 @param competionHandler 操作结果回调
 */
- (void)asyncAddAnonymousEvent:(HMStatisticsAnonymousRecord *)record withCompetion:(nullable AnonymousAsyncWriteBlock)competionHandler;

/**
 批量删除匿名记录

 @param events 待删除记录
 @param competionHandler 删除回调
 */
- (void)asyncDeleteAnonymousEvents:(NSArray<HMStatisticsAnonymousRecord *> *)events withCompetion:(nullable AnonymousAsyncWriteBlock)competionHandler;

#pragma mark - 匿名上下文表

/**
 检查当前上下文是否存在，若不存在则新增上下文

 @param context 带检查上下文
 @param competionHandler 回调处理 isSuccess 是否添加成功 contextID 对应主键
 */
-(void)asyncAddContext:(HMStatisticsAnonymousContextRecord *)context withCompetion:(void(^)(BOOL isSuccess,NSNumber * _Nullable contextID))competionHandler;

/**
 刷新上下文表

 @param context 待刷新上下文
 @param competionHandler 刷新回调
 */
-(void)asyncRefreshContext:(HMStatisticsAnonymousContextRecord *)context withCompetion:(nullable AnonymousAsyncWriteBlock)competionHandler;

@end

NS_ASSUME_NONNULL_END
