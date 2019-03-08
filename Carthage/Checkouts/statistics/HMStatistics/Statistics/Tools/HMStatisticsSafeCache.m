//  HMStatisticsSafeCache.m
//  Created on 2018/4/13
//  Description <#文件描述#>

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author BigNerdCoding wumingliang@huami.com 

#import "HMStatisticsSafeCache.h"

@interface HMStatisticsSafeCache()

@property(strong, nonatomic) dispatch_queue_t  actionQueue;
@property(strong, nonatomic) NSMutableDictionary    *cacheDic;
@end

@implementation HMStatisticsSafeCache

-(instancetype)init {
    self = [super init];
    if (self) {
        _actionQueue = dispatch_queue_create("com.huami.statistics.safeCache",DISPATCH_QUEUE_CONCURRENT);
        _cacheDic = [[NSMutableDictionary alloc] initWithCapacity:7];
    }

    return self;
}

/**
 缓存数据

 @param object 待缓存对象
 @param key 缓存键
 */
-(void)cacheObject:(id)object forKey:(NSString *)key {
    dispatch_barrier_sync(self.actionQueue, ^{
        [self.cacheDic setObject:object forKey:key];
    });
}

/**
 取出缓存数据

 @param key 缓存键
 @return 缓存对象
 */
-(id)getCacheForKey:(NSString *)key {
    __block id object = nil;

    dispatch_sync(self.actionQueue,^{
        object = [self.cacheDic objectForKey:key];
    });

    return object;
}

/**
 移除缓存对象

 @param key 待移除对象键
 */
-(void)removeCacheObjectForKey:(NSString *)key {
    dispatch_barrier_sync(self.actionQueue, ^{
        [self.cacheDic removeObjectForKey:key];
    });
}

/**
 移除所有缓存对象
 */
-(void)removeAllCacheObjects {
    dispatch_barrier_sync(self.actionQueue, ^{
        [self.cacheDic removeAllObjects];
    });
}

/**
 返回所有 key

 @return 返回所有健
 */
-(NSArray<NSString *> *)getAllCacheKeys {
    __block NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:3];

    dispatch_barrier_sync(self.actionQueue, ^{
        allKeys = [[self.cacheDic allKeys] mutableCopy];
    });

    return allKeys;
}

@end
